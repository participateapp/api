defmodule ParticipateApi.TokensSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  use ExVCR.Mock

  alias ParticipateApi.Repo
  alias ParticipateApi.Account
  alias ParticipateApi.Participant

  describe "POST /token" do
    before do: ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")

    let :params, do: %{auth_code: "AQDYCoRocBe5WGPR00Ydw4E8nBM7Ncm8Ld6RaN2VBVzLObUtXynkszCwQKvEtgJJ2Wgmdimm0d0lfkTUmkjA67Ba7NvLSH2ISJcpNH-xS8Hw8cTKUe1aqu_4EMETYx7W4F8Gh3S8zy8_w0pYpw7kt_A6csgyj6OoV7IdcGTjfjidF1h57F8YphETT-4qAcqC2U_hTkt6mW24TURusd3TZ1Bb7JTh7m1qr6v9xFzVaMYUZsmfWN6HjBiPdoVzfHMr_u6PlQCCQGiOIKWPNcJKAQS-11FnazXpVeNOGypFwJvyCVVnX4rQmsci37BAkTXdfrg#_=_"}

    let :user_data,    do: %{"email" => "oli.azevedo.barnes@gmail.com", "id" => "10152845136022407", "name" => "Oliver Azevedo Barnes"}
    let :email,        do:  user_data["email"]
    let :name,         do:  user_data["name"]
    let :facebook_uid, do:  user_data["id"]
    let :account,      do: Repo.one(from a in Account, where: a.email == ^email and a.facebook_uid == ^facebook_uid)
    let :participant,  do: Repo.one(from p in Participant, where: p.name == ^name )

    subject do
      use_cassette "facebook" do
        post(conn(), "/token", params)
      end
    end
    
    it do: should be_successful

    it "creates an account with facebook email and uid" do
      subject
      expect(account).to_not be_nil
    end

    it "creates a participant with facebook name, associated to the account" do
      subject
      expect(participant).to_not be_nil
      participant = Repo.preload(participant, :account)
      expect(participant.account).to eq account
    end

    it "responds with an access token encoding the account" do
      body = Poison.Parser.parse! subject.resp_body
      {:ok, claims} = Guardian.decode_and_verify body["access_token"]
      {:ok, decoded_account} = ParticipateApi.GuardianSerializer.from_token claims["aud"]
      expect(decoded_account).to eq account
    end

    context "an account with the facebook uid already exists" do
      before do: Repo.insert!(%Account{email: email, facebook_uid: facebook_uid})

      it do: should be_successful

      it "doesn't create another account" do
        subject
        query = from a in Account, where: a.email == ^email and a.facebook_uid == ^facebook_uid
        length(Repo.all(query)) == 1
      end

      it "doesn't create another participant" do
        subject
        query = from p in Participant, where: p.name == ^name
        length(Repo.all(query)) == 1
      end

      it "responds with an access token encoding the account" do
        body = Poison.Parser.parse! subject.resp_body
        {:ok, claims} = Guardian.decode_and_verify body["access_token"]
        {:ok, decoded_account} = ParticipateApi.GuardianSerializer.from_token claims["aud"]
        expect(decoded_account).to eq account
      end
    end

    context "when auth code is not present" do
      let :params, do: %{}

      it "400 Bad request" do
        expect(subject).to have_http_status(400)
      end

      it "responds with a error message" do
        expect(subject.resp_body).to eql("{\"error\":\"facebook auth code missing\"}")
      end
    end

    context "when Facebook responds with an error" do
      subject! do
        use_cassette "mock_facebook_error" do
          post(conn(), "/token", params)
        end
      end

      it "500 Internal server error" do
        use_cassette "mock_facebook_error" do
          expect(subject).to have_http_status(500)
        end
      end

      it "responds with an empty response body" do
        use_cassette "mock_facebook_error" do
          expect(subject.resp_body).to eql("")
        end
      end
    end
  end
end
