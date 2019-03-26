defmodule Stockproject.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :amount, :float
    field :purchased_price, :float
    field :quantity, :integer
    has_one :stock, Stockproject.Stocks.Stock
    belongs_to :portfolio, Stockproject.Portfolios.Portfolio

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:amount, :quantity, :purchased_price])
    |> validate_required([:amount, :quantity, :purchased_price])
  end
end
