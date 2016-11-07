defmodule ParticipateApi.ProposalWithSupportCountView do
  use JaSerializer.PhoenixView
  alias ParticipateApi.Repo

  attributes [:support_count]

  def type(_post,_conn), do: "proposal"

  # TODO: move support_count to a helper module
  # once delegations are in and support weight 
  # will have a more complex calculation
  def support_count(proposal, _conn) do
    proposal_with_supports = proposal |> Repo.preload(:supports)
    length(proposal_with_supports.supports)
  end

  def preload(proposal, _conn, _opts) do
    proposal |> ParticipateApi.Repo.preload(:author) 
  end
end
