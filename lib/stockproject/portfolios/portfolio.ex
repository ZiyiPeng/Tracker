defmodule Stockproject.Portfolios.Portfolio do
  use Ecto.Schema
  import Ecto.Changeset

  schema "portfolio" do
    field :name, :string
    belongs_to :user, Stockproject.Users.User
    has_many :records, Stockproject.Records.Record

    timestamps()
  end

  @doc false
  def changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
  end
end
