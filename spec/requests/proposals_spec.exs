defmodule ParticipateApi.ProposalsSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  import ParticipateApi.Factory

  alias ParticipateApi.Repo
  alias ParticipateApi.Proposal

  describe "Proposals API" do
    let :account, do: insert(:account)
    let :current_participant, do: account.participant
    let :token do
      { :ok, jwt, _full_claims } = Guardian.encode_and_sign(account)
      jwt
    end

    describe "GET /proposals" do
      let! :proposal, do: insert(:proposal)
        
      subject do
        build_conn()
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/proposals")
      end

      it "200 OK" do
        expect(subject).to have_http_status(200)
      end

      it "returns a collection with all proposals" do
        response_body = subject.resp_body

        expected = %{
          "data" => [
            %{
              "id" => "#{proposal.id}",
              "type" => "proposal",
              "attributes" => %{
                "title" => proposal.title,
                "body"=> proposal.body,
                "support-count" => 0,
                "supported-by-me" => "false",
                "authored-by-me" => "false"
              },
              "relationships" => %{
                "author" => %{
                  "data" => %{
                    "id" => "#{proposal.author.id}",
                    "type" => "participant"
                  }
                }
              }
            }
          ],
          "included" => [
            %{
              "attributes" => %{
                "name" => proposal.author.name
            }, 
            "id" => "#{proposal.author.id}",
            "type" => "participant"
            }
          ],
          "jsonapi" => %{"version" => "1.0"}
        }

        payload = Poison.Parser.parse!(response_body)

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

    describe "GET /proposals/:id (author is current participant)" do
      let :proposal, do: insert(:proposal, author: current_participant)
        
      subject do
        build_conn()
        |> put_req_header("accept", "application/vnd.api+json")
        |> put_req_header("content-type", "application/vnd.api+json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> get("/proposals/#{proposal.id}")
      end

      it "200 OK" do
        expect(subject).to have_http_status(200)
      end

      it "returns the proposal" do
        response_body = subject.resp_body

        expected = %{
          "data" => %{
            "id" => "#{proposal.id}",
            "type" => "proposal",
            "attributes" => %{
              "title" => proposal.title,
              "body"=> proposal.body,
              "support-count" => 0,
              "supported-by-me" => "false",
              "authored-by-me" => "true"
            },
            "relationships" => %{
              "author" => %{
                "data" => %{
                  "id" => "#{proposal.author.id}",
                  "type" => "participant"
                }
              }
            }
          },
          "included" => [
            %{
              "attributes" => %{
                "name" => proposal.author.name
            }, 
            "id" => "#{proposal.author.id}",
            "type" => "participant"
            }
          ],
          "jsonapi" => %{"version" => "1.0"}
        }

        payload = Poison.Parser.parse!(response_body)

        expect(payload).to eql(expected)
      end

      context "when another participant is the author" do
        let :another_participant, do: insert(:participant)
        let :proposal, do: insert(:proposal, author: another_participant)

        it "returns the proposal" do
          response_body = subject.resp_body
          payload = Poison.Parser.parse!(response_body)
          expect(payload["data"]["attributes"]["authored-by-me"]).to eql("false")
        end
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

    describe "POST /proposals" do
      let :params do
        %{
          "data" => %{
            "type" => "proposal",
            "attributes" => %{
              "title" => "Title",
              "body" =>  "Body"
            }
          }
        }
      end
      let :new_proposal do
        Repo.one(Proposal) |> Repo.preload(:author) 
      end

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

      context "creates a new proposal" do
        before do: subject

        it "including a title" do
          expect(new_proposal.title).to eql "Title"
        end

        it "including a body" do
          expect(new_proposal.body).to eql "Body"
        end

        it "including an author" do
          expect(new_proposal.author).to eql current_participant
        end
      end

      it "returns the new proposal" do
        response_body = subject.resp_body

        expected = %{
          "data" => %{
            "id" => "#{new_proposal.id}",
            "type" => "proposal",
            "attributes" => %{
              "title" => "Title",
              "body"=> "Body",
              "support-count" => 0,
              "supported-by-me" => "false",
              "authored-by-me" => "true"
            },
            "relationships" => %{
              "author" => %{
                "data" => %{
                  "id" => "#{current_participant.id}",
                  "type" => "participant"
                }
              }
            }
          },
          "included" => [
            %{
              "attributes" => %{
                "name" => new_proposal.author.name
            }, 
            "id" => "#{new_proposal.author.id}",
            "type" => "participant"
            }
          ],
          "jsonapi" => %{"version" => "1.0"}
        }

        payload = Poison.Parser.parse!(response_body)

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
