defmodule ParticipateApi.SupportView do
  use JaSerializer.PhoenixView
  
  has_one :proposal,
    serializer: ProposalWithSupportCountView,
    include: true

  def preload(record, _conn, _opts) do
    record |> ParticipateApi.Repo.preload(:proposal) 
  end
end
