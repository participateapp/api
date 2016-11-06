defmodule ParticipateApi.ProposalWithSupportCountView do
  use ParticipateApi.Web, :view
  alias ParticipateApi.Repo

  def type(_post,_conn), do: "proposal"

  def support_count(proposal, _conn) do
    # Repo.aggregate(proposal.supports, :count, :id)
    0
  end
end
