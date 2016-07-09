defmodule ParticipateApi.TokensSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint

  alias ParticipateApi.Repo
  alias ParticipateApi.Account

  describe "POST /token" do
    let :params, do: %{auth_code: "authenticationcode"}

    # let :user_data, do: stub_facebook_requests!
    let :user_data, do: %{name: 'Oliver', email: "oliverbwork@gmail.com"}
    let :name,  do:  user_data[:name]
    let :email, do:  user_data[:email]

    subject! do: post(conn(), "/token", params)
    
    it do: should be_successful

    it "creates an account" do
      expect(Repo.one(from a in Account, where: a.email == ^email)).to_not be_nil
    end

    context "when auth code is not present" do
      let :params, do: %{}

      it "400 Bad request" do
        expect(subject).to have_http_status(400)
      end

      # it 'responds with a error message' do
      #   subject

      #   expect(response.body).to eql('{"error":"facebook auth code missing"}')
      # end
    end
  end
end
