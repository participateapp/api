defmodule ParticipateApi.TokenController do
  use ParticipateApi.Web, :controller

  # def create(conn, %{"auth_code" => auth_code}) do
  def create(conn, _params) do
    conn
    |> put_status(200)
  end
end
