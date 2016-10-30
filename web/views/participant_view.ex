defmodule ParticipateApi.ParticipantView do
  use ParticipateApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]
end

