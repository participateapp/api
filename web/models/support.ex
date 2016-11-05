defmodule ParticipateApi.Support do
  use ParticipateApi.Web, :model

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
  end
end
