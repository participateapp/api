defmodule ParticipateApi.Repo.Migrations.IndexAccountParticipantId do
  use Ecto.Migration

  def change do
    create index(:accounts, [:participant_id])
  end
end
