defmodule ParticipateApi.SupportAuthorValidator do
  import Ecto.Changeset
  import Ecto.Query
  alias ParticipateApi.Repo
  alias ParticipateApi.Support
  alias ParticipateApi.Proposal

  def validate_no_previous_support_given_by_author(changeset) do
    if changeset.valid? do
      author_id = get_field(changeset, :author_id)
      proposal_id = get_field(changeset, :proposal_id)

      query = from s in Support,
        where: [author_id: ^author_id, proposal_id: ^proposal_id]

      if Repo.aggregate(query, :count, :id) > 0 do
        changeset = add_error(changeset, :author, "already supports this proposal")
      end
    end

    changeset
  end

  def validate_supporter_not_author_of_proposal(changeset) do
    if changeset.valid? do
      proposal_id = get_field(changeset, :proposal_id)
      author_id = get_field(changeset, :author_id)

      query = from Proposal,
        where: [id: ^proposal_id, author_id: ^author_id]

      if Repo.one(query) do
        changeset = add_error(changeset, :author, "can't support own proposal")
      end
    end

    changeset
  end
end
