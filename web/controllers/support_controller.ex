defmodule ParticipateApi.SupportController do
  use ParticipateApi.Web, :controller
  use Guardian.Phoenix.Controller

  alias ParticipateApi.Participant
  alias ParticipateApi.Support
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def create(conn, %{"data" => data}, account, _claims) do
    conn = assign(conn, :account, account)
    query = from Participant, where: [id: ^account.participant_id]
    me = Repo.one(query)

    changeset = 
      me
      |> Ecto.build_assoc(:supports)
      |> Support.changeset(Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, proposal} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", proposal_path(conn, :show, proposal))
        |> render("show.json-api", data: proposal)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end
end
