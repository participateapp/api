defmodule ParticipateApi.ProposalController do
  use ParticipateApi.Web, :controller
  use Guardian.Phoenix.Controller

  alias ParticipateApi.Proposal

  def create(conn, %{"data" => %{"attributes" => proposal_params}}, account, _claims) do
    # not working 
    # Repo.preload account, :participant
    # me = account.participant
    query = from Participant, where: [id: ^account.participant_id]
    me = Repo.one(query)

    changeset = Repo.build_assoc(me, :proposals, proposal_params)
    case Repo.insert(changeset) do
      {:ok, proposal} ->
        conn
        |> put_status(204)
        |> put_resp_header("location", proposal_path(conn, :show, proposal))
        |> render(data: proposal)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end
end
