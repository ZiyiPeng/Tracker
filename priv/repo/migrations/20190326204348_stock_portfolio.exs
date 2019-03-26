defmodule Stockproject.Repo.Migrations.StockPortfolio do
  use Ecto.Migration

  def change do
    create table("stock_portfolio") do
      add :stock_id, references(:stocks, on_delete: :delete_all), null: false
      add :portfolio_id, references(:portfolio, on_delete: :delete_all), null: false
    end

    create index(:stock_portfolio, [:portfolio_id])
  end
end
