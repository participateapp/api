defmodule ParticipateApi.TokensSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  import ParticipateApi.Factory

  describe "Me API" do
    let :account, do: insert(:account)
    let :current_participant, do: account.participant
    let :token, do: Guardian.encode_and_sign(account)
    let :headers do
      %{
        "Accept":        "application/vnd.api+json",
        "Content-type":  "application/vnd.api+json",
        "Authorization": "Bearer #{token}"
      }
    end

    describe "GET /me" do

      subject do: get "/me", %{}, headers

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
