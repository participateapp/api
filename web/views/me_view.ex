defmodule ParticipateApi.MeView do
  use ParticipateApi.Web, :view

  location :url

  def url(participant, conn) do
    participant_url(conn, :show, participant.id)
  end

  def type(_post,_conn), do: "participants"
end
