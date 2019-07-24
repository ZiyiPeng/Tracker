defmodule Stockproject.Records do
  @moduledoc """
  The Records context.
  """

  import Ecto.Query, warn: false
  alias Stockproject.Repo

  alias Stockproject.Records.Record

  @doc """
  Returns the list of records.

  ## Examples

      iex> list_records()
      [%Record{}, ...]

  """
  def list_records do
    Repo.all(Record)
  end

  @doc """
  Gets a single record.

  Raises `Ecto.NoResultsError` if the Record does not exist.

  ## Examples

      iex> get_record!(123)
      %Record{}

      iex> get_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_record!(id), do: Repo.get!(Record, id)

  def get_record(id) do
    Repo.one from r in Record,
      where: r.id == ^id
  end

  @doc """
  Creates a record.

  ## Examples

      iex> create_record(%{field: value})
      {:ok, %Record{}}

      iex> create_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_record(attrs \\ %{}) do
    portfolio = Stockproject.Portfolios.get_portfolio(attrs["portfolio_id"])

    %Record{}
    |> Record.changeset(attrs)
    |> Repo.insert!
    |> Repo.preload([:portfolio])
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:portfolio, portfolio)
    |> Repo.update
  end

  @doc """
  Updates a record.

  ## Examples

      iex> update_record(record, %{field: new_value})
      {:ok, %Record{}}

      iex> update_record(record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_record(%Record{} = record, attrs) do
    record
    |> Record.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Record.

  ## Examples

      iex> delete_record(record)
      {:ok, %Record{}}

      iex> delete_record(record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_record(%Record{} = record) do
    Repo.delete(record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking record changes.

  ## Examples

      iex> change_record(record)
      %Ecto.Changeset{source: %Record{}}

  """
  def change_record(%Record{} = record) do
    Record.changeset(record, %{})
  end

  def calc_current_value(id) do
    record = get_record(id)
    stock = Stockproject.Stocks.get_stock(record.stock_id)
    price = StockUtil.get_current_price(stock.abbreviation)
    price * record.quantity
  end

  #%{abbrev, risk, beta, ror}
  #risk is unweighted
  def calc_weighted_stats(record_id, total) do
    record = get_record(record_id)
    stock = Stockproject.Stocks.get_stock!(record.stock_id)
    weight = record.amount / total
    risk = stock.risk
    beta = stock.beta * weight
    ror = stock.rate_of_return * weight
    %{abbreviation: stock.abbreviation, risk: risk, beta: beta, ror: ror, weight: weight}
  end

  def calc_weight_in_portfolio(record_id, total) do
    record = get_record(record_id)
    stock = Stockproject.Stocks.get_stock!(record.stock_id)
    weight = record.amount / total
    %{abbreviation: stock.abbreviation, weight: weight}
  end

  def get_historical_value(record_id) do
    record = get_record(record_id)
    stock = Stockproject.Stocks.get_stock!(record.stock_id)
    history = StockUtil.get_history(stock.abbreviation, "1y")
    #IO.inspect(history)
    Enum.map(history, fn x -> %{"date": x.date, "value": x.close * record.quantity} end)
  end


end
