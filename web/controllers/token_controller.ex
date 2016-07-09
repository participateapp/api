defmodule ParticipateApi.TokenController do
  use ParticipateApi.Web, :controller

  alias ParticipateApi.Account

  def create(conn, %{"auth_code" => auth_code}) do
    # facebook_params = Facebook.fetch_user(params[:auth_code])
    # email_and_uid = %{email: facebook_params[:email], facebook_uid: facebook_params[:id]}
    changeset = Account.changeset(%Account{}, %{email: "oliverbwork@gmail.com", facebook_uid: "11111"})
    case Repo.insert(changeset) do
      {:ok, _account} -> 
        conn
        |> put_status(200)
    end
  end

  def create(conn, _) do
    conn
    |> put_status(400)
  end
end
