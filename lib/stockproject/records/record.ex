defmodule Stockproject.Records.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :amount, :float
    field :purchased_price, :float
    field :quantity, :integer
    field :stock_id, :integer
    belongs_to :portfolio, Stockproject.Portfolios.Portfolio

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    IO.inspect(attrs)
    record
    |> cast(attrs, [:amount, :quantity, :purchased_price, :stock_id])
    |> validate_required([:amount, :quantity, :purchased_price])
  end
end
