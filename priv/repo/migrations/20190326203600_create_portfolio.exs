defmodule Stockproject.Repo.Migrations.CreatePortfolio do
  use Ecto.Migration

  def change do
    create table(:portfolio) do
      add :name, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

  end
end
