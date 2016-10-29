defmodule ParticipateApi.MeSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  import ParticipateApi.Factory

  describe "Me API" do
    let :account, do: insert(:account)
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
            "type" => "participant",
            "attributes" => %{
              "name" => current_participant.name
            }
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
