defmodule ParticipateApi.ProposalWithSupportCountView do
  use JaSerializer.PhoenixView
  alias ParticipateApi.Repo

  attributes [:support_count, :supported_by_me]

  def type(_post,_conn), do: "proposal"

  # TODO: move support_count to a helper module
  # once delegations are in and support weight 
  # will have a more complex calculation
  def support_count(proposal, _conn) do
    proposal_with_supports = proposal |> Repo.preload(:supports)
    length(proposal_with_supports.supports)
  end

  # this is also used in ProposalView
  # TODO: dry up both views, make them share common functions
  def supported_by_me(proposal, conn) do
    proposal_with_supports = proposal |> Repo.preload(:supports)
    support_author_ids = Enum.map(proposal_with_supports.supports, fn(support) -> support.author_id end)

    me_id = conn.assigns[:account].participant_id

    if me_id in support_author_ids do
      "true"
    else
      "false"
    end
  end

  def preload(proposal, _conn, _opts) do
    proposal |> ParticipateApi.Repo.preload(:author) 
  end
end
