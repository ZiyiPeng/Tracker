defmodule Stockproject.Repo.Migrations.CreateRecords do
  use Ecto.Migration

  def change do
    create table(:records) do
      #monetary amount
      add :amount, :float
      #how many stocks you purchased
      add :quantity, :integer
      add :purchased_price, :float
      add :stock_id, references(:stocks, on_delete: :delete_all)
      add :portfolio_id, references(:portfolio, on_delete: :delete_all)

      timestamps()
    end

    create index(:records, [:stock_id])
    create index(:records, [:portfolio_id])
  end
end
