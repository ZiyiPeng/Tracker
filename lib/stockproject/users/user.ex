defmodule Stockproject.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password_hash, :string
    field :name, :string
    has_one :portfolio, Stockproject.Portfolios.Portfolio
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password_hash])
    |> validate_required([:username, :password_hash])
  end
end
