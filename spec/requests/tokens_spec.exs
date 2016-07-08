defmodule ParticipateApi.TokensSpec do
  use ESpec.Phoenix, request: ParticipateApi.Endpoint

  describe "POST /token" do
    let :params, do: %{auth_code: "authenticationcode"}

    subject! do: post(conn(), "/token", params)
    
    it do: should be_successful
  end
end
