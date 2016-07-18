defmodule ParticipateApi.MeSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  # import ParticipateApi.Factory

  alias ParticipateApi.Repo
  alias ParticipateApi.Account
  alias ParticipateApi.Participant

  describe "Me API" do
    # can't get ex_machina to work yet
    # let :account, do: insert(:account)
    let :account do
      participant = Repo.insert!(%Participant{name: "David Harvey"})
      email_and_uid = %{email: "david@harvey.net", facebook_uid: "111111111"}      
      build_account = Ecto.build_assoc(participant, :account, email_and_uid)
      Repo.insert!(build_account)
    end
    let :current_participant do
      account.participant
    end
    let :token, do: Guardian.encode_and_sign(account)

    describe "GET /me" do
      subject do
        get(build_conn(), "/me")
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
      end

      it "200 OK" do
        expect(subject).to have_http_status(200)
      end

      it "current participant" do
        expected = %{
          data: %{
            id: current_participant.id,
            type: "participants",
            links: %{
              self: "http://www.example.com/participants/#{current_participant.id}"
            }
          }
        }

        payload = Poison.Parser.parse!(subject.resp_body)

        expect(payload).to eql(expected)
      end

      # it_behaves_like "token is invalid"
    end
  end
end
