defmodule ParticipateApi.Repo.Migrations.CreateParticipant do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :name, :string

      timestamps
    end

  end
end
