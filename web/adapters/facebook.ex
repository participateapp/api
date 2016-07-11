defmodule ParticipateApi.Facebook do
  def fetch_user(fb_dialog_response_code) do
    request_access_token(fb_dialog_response_code) |> request_user_data
  end

  def request_access_token(fb_dialog_response_code) do
    response = token_url(fb_dialog_response_code) |> request
    response["access_token"]
  end

  defp request_user_data(access_token) do
    me_url(access_token) |> request
  end

  defp request(url) do
    response = HTTPotion.get(url)
    body = Poison.Parser.parse! response.body

    unless response.status_code == 200, do: raise(body["error"]["message"]) 
    
    body
  end

  defp token_url(fb_dialog_response_code) do
    # to get sample fb dialog response code for manual testing:
    # https://www.facebook.com/dialog/oauth?client_id=1583083701926004&redirect_uri=http://localhost:4200/
    "https://graph.facebook.com/v2.3/oauth/access_token?#{token_query(fb_dialog_response_code)}"
  end

  defp token_query(fb_dialog_response_code) do
    # TODO move to env vars
    "client_id=1583083701926004&client_secret=16b9c526400d10d95589b168dae80d4d&redirect_uri=http://localhost:4200/&code=#{fb_dialog_response_code}"
  end

  defp me_url(access_token) do
    "https://graph.facebook.com/v2.3/me?fields=email,name&access_token=#{access_token}"
  end
end
