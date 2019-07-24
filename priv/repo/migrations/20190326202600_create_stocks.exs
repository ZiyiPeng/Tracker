defmodule Stockproject.Repo.Migrations.CreateStocks do
  use Ecto.Migration

  def change do
    create table(:stocks) do
      add :name, :string, null: false
      add :abbreviation, :string, null: false
      add :return_fluc, :float, null: false
      add :price_fluc, :float, null: false
      add :modified_date, :utc_datetime, default: DateTime.to_string(DateTime.utc_now)
      add :rate_of_return, :float, null: false
      add :beta, :float, null: false
      timestamps()
    end

  end
end
