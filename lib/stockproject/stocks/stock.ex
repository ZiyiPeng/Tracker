defmodule Stockproject.Stocks.Stock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stocks" do
    field :abbreviation, :string
    field :modified_date, :utc_datetime
    field :name, :string
    field :risk, :float
    field :beta, :float
    field :rate_of_return, :float

    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:name, :abbreviation, :risk, :modified_date, :beta, :rate_of_return])
    |> validate_required([:name, :abbreviation, :risk, :modified_date])
  end
end
