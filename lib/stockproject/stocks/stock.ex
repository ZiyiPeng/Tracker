defmodule Stockproject.Stocks.Stock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stocks" do
    field :abbreviation, :string
    field :modified_date, :utc_datetime
    field :name, :string
    field :return_fluc, :float
    field :price_fluc, :float
    field :beta, :float
    field :rate_of_return, :float

    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:name, :abbreviation, :return_fluc, :price_fluc, :modified_date, :beta, :rate_of_return])
    |> validate_required([:name, :abbreviation])
  end
end
