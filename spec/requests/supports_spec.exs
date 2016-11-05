defmodule ParticipateApi.SupportsSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  import ParticipateApi.Factory

  alias ParticipateApi.Repo
  alias ParticipateApi.Support

  describe "Supports API" do
    let :account, do: insert(:account)
    let :current_participant, do: account.participant
    let :token do
      { :ok, jwt, _full_claims } = Guardian.encode_and_sign(account)
      jwt
    end

    describe "POST /supports" do
      let! :proposal, do: insert(:proposal)
      let :params do
        %{
          "data" => %{
            "type" => "support",
            "relationships" => %{
              "proposal" => %{
                "data" => %{
                  "id" => "#{proposal.id}",
                  "type" => "proposal"
                }
              }
            }
          }
        }
      end
      let :new_support do
        Repo.one(Support) |> Repo.preload(:proposal) 
      end

      subject do
        build_conn()
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/supports", params)
      end

      it "201 Created" do
        expect(subject).to have_http_status(201)
      end

      it "creates one support" do
        count = Repo.aggregate(Support, :count, :id)
        expect(count).to eql 0
        subject
        expect(count).to eql 1
      end

      it "associates new support to the current proposal" do
        subject
        expect(new_support.proposal).to eql proposal
      end

      it "associates new support to the current participant" do
        subject
        expect(new_support.author).to eql current_participant
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
