defmodule ParticipateApi.Repo.Migrations.CreateProposal do
  use Ecto.Migration

  def change do
    create table(:proposals) do
      add :title, :string
      add :body, :string
      add :author_id, references(:participants, on_delete: :delete_all)
      add :previous_proposal_id, references(:proposals, on_delete: :nothing)

      timestamps()
    end
    create index(:proposals, [:author_id])
    create index(:proposals, [:previous_proposal_id])

    alter table(:participants) do
      add :proposal_id, references(:proposals, on_delete: :nothing)
    end
    create index(:participants, [:proposal_id])
  end
end
