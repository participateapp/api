defmodule ParticipateApi.TokensSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint
  use ExVCR.Mock

  alias ParticipateApi.Repo
  alias ParticipateApi.Account

  describe "POST /token" do
    before do: ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")

    let :params, do: %{auth_code: "AQDYCoRocBe5WGPR00Ydw4E8nBM7Ncm8Ld6RaN2VBVzLObUtXynkszCwQKvEtgJJ2Wgmdimm0d0lfkTUmkjA67Ba7NvLSH2ISJcpNH-xS8Hw8cTKUe1aqu_4EMETYx7W4F8Gh3S8zy8_w0pYpw7kt_A6csgyj6OoV7IdcGTjfjidF1h57F8YphETT-4qAcqC2U_hTkt6mW24TURusd3TZ1Bb7JTh7m1qr6v9xFzVaMYUZsmfWN6HjBiPdoVzfHMr_u6PlQCCQGiOIKWPNcJKAQS-11FnazXpVeNOGypFwJvyCVVnX4rQmsci37BAkTXdfrg#_=_"}

    let :user_data, do: %{"email" => "oli.azevedo.barnes@gmail.com", "id" => "10152845136022407", "name" => "Oliver Azevedo Barnes"}
    let :email, do:  user_data["email"]

    subject! do
      use_cassette "facebook" do
        post(conn(), "/token", params)
      end
    end
    
    it do: should be_successful

    it "creates an account" do
      expect(Repo.one(from a in Account, where: a.email == ^email)).to_not be_nil
    end

    context "when auth code is not present" do
      let :params, do: %{}

      it "400 Bad request" do
        expect(subject).to have_http_status(400)
      end

      it "responds with a error message" do
        subject

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
