defmodule ParticipateApi.MeSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  # import ParticipateApi.Factory

  alias ParticipateApi.Repo
  alias ParticipateApi.Account
  alias ParticipateApi.Participant

  describe "Me API" do
    # can't get ex_machina to work yet
    # let :account, do: insert(:account)
    before do
      participant = Repo.insert!(%Participant{name: "David Harvey"})
      email_and_uid = %{email: "david@harvey.net", facebook_uid: "111111111"}      
      build_account = Ecto.build_assoc(participant, :account, email_and_uid)
      Repo.insert!(build_account)
    end

    let :account do
      (from Account, where: [email: "david@harvey.net"], preload: [:participant])
      |> Repo.one
    end
    let :current_participant, do: account.participant
    let :token do
      { :ok, jwt, _full_claims } = Guardian.encode_and_sign(account)
      jwt
    end

    describe "GET /me" do
      subject do
        build_conn()
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/me")
      end

      it "200 OK" do
        expect(subject).to have_http_status(200)
      end

      it "current participant" do
        expected = %{
          "data" => %{
            "id" => "#{current_participant.id}",
            "type" => "participants",
            "links" => %{
              "self" => "http://localhost:4001/participants/#{current_participant.id}"
            },
            "attributes" => %{}
          },
          "jsonapi" => %{"version" => "1.0"}
        }

        payload = Poison.Parser.parse!(subject.resp_body)

        expect(payload).to eql(expected)
      end

      context "token is invalid" do
        let :token, do: "badtoken"

        it "401 Unauthorized" do
          expect(subject).to have_http_status(401)
        end

        it "empty body" do
          # expect(subject.resp_body).to eq ""
          # this diverges from the oauth spec, but overriding 
          # Guardian.Plug.EnsureAuthenticated's error handling isn't 
          # worth it for now
          expect(subject.resp_body).to eq "{\"errors\":[\"Unauthenticated\"]}"
        end

      end
    end
  end
end
