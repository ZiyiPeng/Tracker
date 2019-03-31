defmodule Stockproject.Portfolios do
  @moduledoc """
  The Portfolios context.
  """

  import Ecto.Query, warn: false
  alias Stockproject.Repo

  alias Stockproject.Portfolios.Portfolio

  @doc """
  Returns the list of portfolio.

  ## Examples

      iex> list_portfolio()
      [%Portfolio{}, ...]

  """
  def list_portfolio do
    Repo.all(from p in Portfolio, preload: [:user, :records])
  end

  @doc """
  Gets a single portfolio.

  Raises `Ecto.NoResultsError` if the Portfolio does not exist.

  ## Examples

      iex> get_portfolio!(123)
      %Portfolio{}

      iex> get_portfolio!(456)
      ** (Ecto.NoResultsError)

  """
  def get_portfolio!(id), do: Repo.get!(Portfolio, id)

  def get_portfolio(id) do
    Repo.one from p in Portfolio,
      where: p.id == ^id,
      preload: [:user, :records]
  end

  def get_portfolio_by_username(username) do
    user_id = Stockproject.Users.get_user_by_name(username).id
    Repo.one(from p in Portfolio,
    where: p.user_id == ^user_id,
      preload: [:user, :records])
  end
  @doc """
  Creates a portfolio.

  ## Examples

      iex> create_portfolio(%{field: value})
      {:ok, %Portfolio{}}

      iex> create_portfolio(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_portfolio(attrs \\ %{}) do
    %Portfolio{}
    |> Portfolio.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a portfolio.

  ## Examples

      iex> update_portfolio(portfolio, %{field: new_value})
      {:ok, %Portfolio{}}

      iex> update_portfolio(portfolio, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_portfolio(%Portfolio{} = portfolio, attrs) do
    portfolio
    |> Portfolio.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a Portfolio.

  ## Examples

      iex> delete_portfolio(portfolio)
      {:ok, %Portfolio{}}

      iex> delete_portfolio(portfolio)
      {:error, %Ecto.Changeset{}}

  """
  def delete_portfolio(%Portfolio{} = portfolio) do
    Repo.delete(portfolio)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking portfolio changes.

  ## Examples

      iex> change_portfolio(portfolio)
      %Ecto.Changeset{source: %Portfolio{}}

  """
  def change_portfolio(%Portfolio{} = portfolio) do
    Portfolio.changeset(portfolio, %{})
  end
end
