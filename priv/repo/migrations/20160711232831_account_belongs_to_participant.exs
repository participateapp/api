defmodule ParticipateApi.Repo.Migrations.AccountBelongsToParticipant do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :participant_id, references(:participants, on_delete: :delete_all)
    end
  end
end
