defmodule ParticipateApi.Support do
  use ParticipateApi.Web, :model
  import ParticipateApi.SupportAuthorValidator

  schema "supports" do
    belongs_to :author, ParticipateApi.Participant
    belongs_to :proposal, ParticipateApi.Proposal

    timestamps()
  end

  @required_fields ~w(author_id proposal_id)a
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:proposal)
    |> validate_supporter_not_author_of_proposal
    |> validate_no_previous_support_given_by_author
  end
end
