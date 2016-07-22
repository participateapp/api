defmodule ParticipateApi.MeController do
  use ParticipateApi.Web, :controller
  use Guardian.Phoenix.Controller

  alias ParticipateApi.Participant

  def show(conn, _params, account, _claims) do
    # not working 
    # Repo.preload account, :participant
    # me = account.participant
    query = from Participant, where: [id: ^account.participant_id]
    me = Repo.one(query)
    render conn, data: me
  end
end
