defmodule ParticipateApi.Account do
  use ParticipateApi.Web, :model

  schema "accounts" do
    field :email, :string
    field :facebook_uid, :string
    
    belongs_to :participant, ParticipateApi.Participant

    timestamps
  end

  @required_fields ~w(email facebook_uid)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
  end
end
