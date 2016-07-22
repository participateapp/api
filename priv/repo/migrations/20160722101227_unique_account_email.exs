defmodule ParticipateApi.Repo.Migrations.UniqueAccountEmail do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:email])
  end
end
