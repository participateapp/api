defmodule ParticipateApi.Repo.Migrations.AccountBelongsToParticipant do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :participant_id, :integer
    end
  end
end
