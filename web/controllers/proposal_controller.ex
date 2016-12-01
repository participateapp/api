defmodule ParticipateApi.ProposalController do
  use ParticipateApi.Web, :controller
  use Guardian.Phoenix.Controller

  alias ParticipateApi.Proposal
  alias ParticipateApi.Participant
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params, account, _claims) do
    conn = assign(conn, :account, account)
    proposals = Repo.all(Proposal)
    render(conn, data: proposals)
  end

  def create(conn, %{"data" => data}, account, _claims) do
    conn = assign(conn, :account, account)
    query = from Participant, where: [id: ^account.participant_id]
    me = Repo.one(query)

    changeset = 
      me
      |> Ecto.build_assoc(:proposals)
      |> Proposal.changeset(Params.to_attributes(data))

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

  def show(conn, %{"id" => id}, account, _claims) do
    conn = assign(conn, :account, account)
    proposal = Repo.get!(Proposal, id) |> Repo.preload(:author) 
    render(conn, "show.json-api", data: proposal)
  end

  def update(conn, %{"id" => id, "data" => data}) do
    proposal = Repo.get!(Proposal, id)
    changeset = Proposal.changeset(proposal, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, proposal} ->
        render(conn, "show.json-api", data: proposal)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    proposal = Repo.get!(Proposal, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(proposal)

    send_resp(conn, :no_content, "")
  end

end
