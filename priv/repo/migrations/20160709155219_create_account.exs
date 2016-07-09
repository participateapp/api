defmodule ParticipateApi.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :email, :string
      add :facebook_uid, :string

      timestamps
    end

  end
end
