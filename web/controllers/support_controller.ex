defmodule ParticipateApi.SupportController do
  use ParticipateApi.Web, :controller
  use Guardian.Phoenix.Controller

  alias ParticipateApi.Participant
  alias ParticipateApi.Support
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  # FIXME: should return the created support resource instead 
  # of the updated proposal
  #
  # the proposal is returned here so support-count is updated
  # on the web-client's proposal copy, but this is counter-intuitive and 
  # not RESTful. We can achieve the same by returning the created 
  # support resource with the associated proposal included.
  #
  # Of course, the response decoder on the web-client will 
  # have to be changed to handle the new response
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

  def delete(conn, %{"proposal_id" => proposal_id}, account, _claims) do
    query = from Support, where: [proposal_id: ^proposal_id, author_id: ^account.participant_id]

    support = Repo.one(query)

    if support do
      Repo.delete(support)
      conn |> send_resp(:no_content, "")
    else 
      conn |> send_resp(:forbidden, "")
    end
  end
end
