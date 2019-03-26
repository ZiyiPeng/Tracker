defmodule Stockproject.Portfolios.Portfolio do
  use Ecto.Schema
  import Ecto.Changeset

  schema "portfolio" do
    field :name, :string
    belongs_to :user, Stockproject.Users.User
    has_many :records, Stockproject.Records.Record

    many_to_many :stocks, Stockproject.Stocks.Stock,
    join_through: "stock_portfolio",
    join_keys: [portfolio_id: :id, stock_id: :id],
    on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
