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
        Repo.one(Support)
        |> Repo.preload(:proposal) 
        |> Repo.preload(:author) 
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
        expect(Repo.aggregate(Support, :count, :id)).to eql 0
        subject
        expect(Repo.aggregate(Support, :count, :id)).to eql 1
      end

      it "associates new support to the current proposal" do
        subject
        expect(new_support.proposal.id).to eql proposal.id
      end

      it "associates new support to the current participant" do
        subject
        expect(new_support.author.id).to eql current_participant.id
      end

      it "returns the new proposal" do
        response_body = subject.resp_body

        expected = %{
          "data" => %{
            "id" => "#{new_support.id}",
            "type" => "support",
            "attributes" => %{},
            "relationships" => %{
              "proposal" => %{
                "data" => %{
                  "type" => "proposal",
                  "id" => "#{proposal.id}"
                }
              }
            }
          },
          "included" => [
            %{
              "type" => "proposal",
              "id" => "#{proposal.id}",
              "attributes" => %{
                "support-count" => 1,
                "supported-by-me" => true,
              }
            }
          ], 
          "jsonapi" => %{"version" => "1.0"}
        }

        payload = Poison.Parser.parse!(response_body)

        expect(payload).to eql(expected)
      end

      context "duplicate support by same author" do
        let! :support, do: insert(:support, proposal: proposal, author: current_participant)

        it "422 Unprocessable Entity" do
          expect(subject).to have_http_status(422)
        end

        it "Error: support already given" do
          expect(subject.resp_body)
            .to eq "{\"errors\":[{\"title\":\"already supports this proposal\",\"source\":{\"pointer\":\"/data/attributes/author\"},\"detail\":\"Author already supports this proposal\"}]}"
        end
      end

      context "support author is also the proposal's author" do
        let! :proposal, do: insert(:proposal, author: current_participant)

        it "422 Unprocessable Entity" do
          expect(subject).to have_http_status(422)
        end

        it "Error: proposal author can't support own proposal" do
          expect(subject.resp_body)
            .to eq "{\"errors\":[{\"title\":\"can't support own proposal\",\"source\":{\"pointer\":\"/data/attributes/author\"},\"detail\":\"Author can't support own proposal\"}]}"
        end
      end

      context "token is invalid" do
        let :token, do: "badtoken"

        it "401 Unauthorized" do
          expect(subject).to have_http_status(401)
        end

        it "Unauthenticated error" do
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
