defmodule ParticipateApi.SupportView do
  use JaSerializer.PhoenixView

  alias ParticipateApi.ProposalWithSupportCountView
  
  has_one :proposal,
    serializer: ProposalWithSupportCountView,
    include: true

  def preload(record, _conn, _opts) do
    record |> ParticipateApi.Repo.preload(:proposal) 
  end
end
