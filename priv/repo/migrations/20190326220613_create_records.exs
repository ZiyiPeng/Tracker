defmodule Stockproject.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      #monetary amount
      add :amount, :float, null: false
      #how many stocks you purchased
      add :quantity, :integer, null: false
      add :purchased_price, :float, null: false
      add :portfolio_id, references(:portfolio, on_delete: :delete_all)
      add :stock_id, :integer, null: false
      timestamps()
    end

    create index(:records, [:portfolio_id])
  end
end
