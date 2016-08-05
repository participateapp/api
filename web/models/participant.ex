defmodule ParticipateApi.Participant do
  use ParticipateApi.Web, :model

  schema "participants" do
    field :name, :string

    has_one :account, ParticipateApi.Account
    belongs_to :proposal, ParticipateApi.Proposal #as a delegate for the proposal
    has_many :proposals, ParticipateApi.Proposal, foreign_key: :author_id

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
