defmodule Stockproject.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      #monetary amount
      add :amount, :float
      #how many stocks you purchased
      add :quantity, :integer
      add :purchased_price, :float
      add :portfolio_id, references(:portfolio, on_delete: :delete_all)
      add :stock_id, :integer
      timestamps()
    end

    create index(:records, [:portfolio_id])
  end
end
