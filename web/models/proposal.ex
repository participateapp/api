defmodule ParticipateApi.Proposal do
  use ParticipateApi.Web, :model

  schema "proposals" do
    field :title, :string
    field :body, :string
    
    belongs_to :author, ParticipateApi.Participant
    
    # has_many :supports, ParticipateApi.Support
    # has_many :suggestions, ParticipateApi.Suggestion
    # has_many :delegations, ParticipateApi.Delegation
    # has_many :delegates, ParticipantApi.Participant, foreign_key: :proposal_id

    # has_many :counter_proposals, ParticipateApi.Proposal, foreign_key: :previous_proposal_id
    # belongs_to :previous_proposal, ParticipateApi.Proposal

    timestamps()
  end

  @required_fields ~w(title body author_id)
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
