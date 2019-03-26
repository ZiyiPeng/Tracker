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

    many_to_many :portfolio, Stockproject.Portfolios.Portfolio,
    join_through: "stock_portfolio",
    join_keys: [stock_id: :id, portfolio_id: :id],
    on_replace: :delete


    timestamps()
  end

  @doc false
  def changeset(stock, attrs) do
    stock
    |> cast(attrs, [:name, :abbreviation, :risk, :modified_date])
    |> validate_required([:name, :abbreviation, :risk, :modified_date])
  end
end
