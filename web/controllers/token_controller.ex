defmodule ParticipateApi.TokenController do
  use ParticipateApi.Web, :controller
  require Logger

  alias ParticipateApi.Account
  alias ParticipateApi.Participant
  alias ParticipateApi.Facebook

  def create(conn, %{"auth_code" => auth_code}) do
    facebook_params = Facebook.fetch_user(auth_code)
    
    account = Repo.get_by(Account, facebook_uid: facebook_params["id"])

    if !account do
      {:ok, account} = Repo.transaction fn ->
        participant = Repo.insert!(%Participant{name: facebook_params["name"]})
        email_and_uid = %{email: facebook_params["email"], facebook_uid: facebook_params["id"]}      
        build_account = Ecto.build_assoc(participant, :account, email_and_uid)
        Repo.insert!(build_account)
      end
    end

    conn
    |> put_status(200)
    |> put_access_token(account)
  rescue
    e in RuntimeError -> Logger.warn "\nFacebook API error: #{e.message}\n"
    conn
    |> put_status(500)
    |> text("")
  end

  def create(conn, _) do
    conn
    |> put_status(400)
    |> json(%{error: "facebook auth code missing"})
  end

  defp put_access_token(conn, account) do
    new_conn = Guardian.Plug.api_sign_in(conn, account)
    token = Guardian.Plug.current_token(new_conn)
    json conn, %{access_token: token}
  end
end
