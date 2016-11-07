defmodule ParticipateApi.Repo.Migrations.CreateSupports do
  use Ecto.Migration

  def change do
    create table(:supports) do
      add :author_id, references(:participants, on_delete: :delete_all)
      add :proposal_id, references(:proposals, on_delete: :delete_all)

      timestamps()
    end
    create index(:supports, [:author_id])
    create index(:supports, [:proposal_id])
  end
end
