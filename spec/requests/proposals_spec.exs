defmodule ParticipateApi.ProposalsSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint

  alias ParticipateApi.Repo
  alias ParticipateApi.Account
  alias ParticipateApi.Participant
  alias ParticipateApi.Proposal

  describe "Proposals API" do
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

    describe "POST /proposals" do
      let :params do
        %{
          "data" => %{
            "type" => "proposals",
            "attributes" => %{
              "title" => "New title",
              "body" =>  "New body"
            }
          }
        }
      end
      let :new_proposal, do: Repo.first(Proposal)

      subject do
        build_conn()
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/proposals", params)
      end

      it "201 Created" do
        expect(subject).to have_http_status(201)
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
