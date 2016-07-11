defmodule ParticipateApi.FacebookSpec do
  use ESpec
  use ExVCR.Mock

  alias ParticipateApi.Facebook

  describe ".fetch_user" do
    before do: ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")

    let :user_data, do: %{"email" => "oli.azevedo.barnes@gmail.com", "id" => "10152845136022407", "name" => "Oliver Azevedo Barnes"}
    
    subject do: Facebook.fetch_user("AQDYCoRocBe5WGPR00Ydw4E8nBM7Ncm8Ld6RaN2VBVzLObUtXynkszCwQKvEtgJJ2Wgmdimm0d0lfkTUmkjA67Ba7NvLSH2ISJcpNH-xS8Hw8cTKUe1aqu_4EMETYx7W4F8Gh3S8zy8_w0pYpw7kt_A6csgyj6OoV7IdcGTjfjidF1h57F8YphETT-4qAcqC2U_hTkt6mW24TURusd3TZ1Bb7JTh7m1qr6v9xFzVaMYUZsmfWN6HjBiPdoVzfHMr_u6PlQCCQGiOIKWPNcJKAQS-11FnazXpVeNOGypFwJvyCVVnX4rQmsci37BAkTXdfrg#_=_")

    it "returns a hash with the user data" do
      use_cassette "facebook" do
        expect(subject).to eql user_data
      end
    end

    context "on facebook api failure" do
      focus "raises a RuntimeError with the server's error message" do
        use_cassette "mock_facebook_error" do
          expect fn -> subject end  |> to(raise_exception)
        end
      end
    end
  end
end
