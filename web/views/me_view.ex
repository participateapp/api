defmodule ParticipateApi.MeView do
  use ParticipateApi.Web, :view

  def type(_post,_conn), do: "participant"
end
