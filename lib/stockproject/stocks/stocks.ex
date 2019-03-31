defmodule Stockproject.Stocks do
  @moduledoc """
  The Stocks context.
  """

  import Ecto.Query, warn: false
  alias Stockproject.Repo
  alias StockUtil

  alias Stockproject.Stocks.Stock

  @doc """
  Returns the list of stocks.

  ## Examples

      iex> list_stocks()
      [%Stock{}, ...]

  """
  def list_stocks do
    stocks = Repo.all(Stock)
    Enum.map(stocks, fn x-> Map.put(x, :logo, StockUtil.get_logo(x.abbreviation)) end)
  end

#update the given stock if necessary
#add a new stock to the database if the one we are looking for does not exist
  def prepare_stock(abbrev) do
    target = Repo.get_by(Stock, abbreviation: abbrev)
    #stock is in the database, check updated date
    if target do
      if need_update(target) do
        risk = StockUtil.calc_risk(abbrev)
        ror = StockUtil.get_annual_ror(abbrev)
        %{beta: beta, name: name} = StockUtil.get_info(abbrev)
        update_stock(target, %{risk: risk, beta: beta, rate_of_return: ror, name: name})
      else
        target
      end
    else
      risk = StockUtil.calc_risk(abbrev)
      ror = StockUtil.get_annual_ror(abbrev)
      %{beta: beta, name: name} = StockUtil.get_info(abbrev)
      create_stock(%{name: name, beta: beta, rate_of_return: ror, risk: risk, abbreviation: abbrev})
    end
  end

  #a stock's info needs to be updated every 2 month
  def need_update(stock) do
    time_now = DateTime.utc_now()
    diff_sec = DateTime.diff(stock.modified_date, time_now)
    diff_sec > 2*30*24*60*60
  end

  @doc """
  Gets a single stock.

  Raises `Ecto.NoResultsError` if the Stock does not exist.

  ## Examples

      iex> get_stock!(123)
      %Stock{}

      iex> get_stock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stock!(id), do: Repo.get(Stock, id)

  def get_stock(id) do
    stock = Repo.get(Stock, id)
    Map.put(stock, :logo, StockUtil.get_logo(stock.abbreviation))
  end
  @doc """
  Creates a stock.

  ## Examples

      iex> create_stock(%{field: value})
      {:ok, %Stock{}}

      iex> create_stock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stock(attrs \\ %{}) do
    %Stock{}
    |> Stock.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a stock.

  ## Examples

      iex> update_stock(stock, %{field: new_value})
      {:ok, %Stock{}}

      iex> update_stock(stock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stock(%Stock{} = stock, attrs) do
    stock
    |> Stock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Stock.

  ## Examples

      iex> delete_stock(stock)
      {:ok, %Stock{}}

      iex> delete_stock(stock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stock(%Stock{} = stock) do
    Repo.delete(stock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stock changes.

  ## Examples

      iex> change_stock(stock)
      %Ecto.Changeset{source: %Stock{}}

  """
  def change_stock(%Stock{} = stock) do
    Stock.changeset(stock, %{})
  end
end
