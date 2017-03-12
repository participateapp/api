defmodule ParticipateApi.SupportAuthorValidator do
  import Ecto.Changeset
  import Ecto.Query
  alias ParticipateApi.Support
  alias ParticipateApi.Repo

  def validate_no_previous_support_given_by_author(changeset) do
    if changeset.valid? do
      author_id = get_field(changeset, :author_id)
      proposal_id = get_field(changeset, :proposal_id)

      query = from s in Support, 
        where: [author_id: ^author_id, proposal_id: ^proposal_id]

      if Repo.aggregate(query, :count, :id) > 0 do
        changeset = add_error(changeset, :author, "Already supports this proposal")
      end
    end

    changeset
  end

  # WIP
  # TODO: add tests
  # def validate_not_the_proposal_author(changeset) do
  #   proposal_id = get_field(changeset, :proposal_id)
  #   author_id = get_field(changeset, :author_id)

  #   query = from Proposal, where: [id: proposal_id]
  #   proposal = Repo.one(query)

  #   if proposal.author_id == author_id do
  #     # add error
  #   end

  #   changeset
  # end
end
