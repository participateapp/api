defmodule ParticipateApi.ProposalView do
  use JaSerializer.PhoenixView

  alias ParticipateApi.Repo
  alias ParticipateApi.ParticipantView

  attributes [:title, :body, :support_count, :authored_by_me]
  
  has_one :author,
    serializer: ParticipantView,
    include: true

  # TODO: move support_count to a helper module
  # once delegations are in and support weight 
  # will have a more complex calculation
  def support_count(proposal, _conn) do
    proposal_with_supports = proposal |> Repo.preload(:supports)
    length(proposal_with_supports.supports)
  end

  def authored_by_me(proposal, conn) do
    if proposal.author.id == conn.assigns[:account].participant_id do
      "true"
    else
      "false"
    end
  end

  def preload(proposal, _conn, _opts) do
    proposal |> Repo.preload(:author) 
  end

  # has_one :previous_proposal,
  #   field: :previous_proposal_id,
  #   type: "proposal",
  #   links: [
  #     related: "/proposals/:id/previous-proposal",
  #     self: "/proposals/:id/relationships/previous-proposal"
  #   ]
  # has_many :counter_proposals,
  #   links: [
  #     related: "/proposals/:id/counter-proposals",
  #     self: "/proposals/:id/relationships/counter-proposals"
  #   ]
  # has_many :supports,
  #   links: [
  #     related: "/proposals/:id/supports",
  #     self: "/proposals/:id/relationships/supports"
  #   ]
  # has_many :delegates,
  #   links: [
  #     related: "/proposals/:id/delegates",
  #     self: "/proposals/:id/relationships/delegates"
  #   ]
  # has_many :delegations,
  #   links: [
  #     related: "/proposals/:id/delegations",
  #     self: "/proposals/:id/relationships/delegations"
  #   ]
  # has_many :suggestions,
  #   links: [
  #     related: "/proposals/:id/suggestions",
  #     self: "/proposals/:id/relationships/suggestions"
  #   ]
end
