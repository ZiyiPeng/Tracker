defmodule StockprojectWeb.StockController do
  use StockprojectWeb, :controller

  alias Stockproject.Stocks
  alias Stockproject.Stocks.Stock

  action_fallback StockprojectWeb.FallbackController

  def init(args) do
    args
  end

  def index(conn, _params) do
    stocks = Stocks.list_stocks()
    render(conn, "index.json", stocks: stocks)
  end

  def create(conn, %{"stock" => stock_params}) do
    with {:ok, %Stock{} = stock} <- Stocks.create_stock(stock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.stock_path(conn, :show, stock))
      |> render("show.json", stock: stock)
    end
  end

  def show(conn, %{"id" => id}) do
    stock = Stocks.get_stock!(id)
    render(conn, "show.json", stock: stock)
  end

  def update(conn, %{"id" => id, "stock" => stock_params}) do
    stock = Stocks.get_stock!(id)

    with {:ok, %Stock{} = stock} <- Stocks.update_stock(stock, stock_params) do
      render(conn, "show.json", stock: stock)
    end
  end

  def delete(conn, %{"id" => id}) do
    stock = Stocks.get_stock!(id)

    with {:ok, %Stock{}} <- Stocks.delete_stock(stock) do
      send_resp(conn, :no_content, "")
    end
  end

  def look_up_company(conn, %{"abbreviation" => ab}) do
    result = Stoxir.company(ab)
    render(conn, "company.json", company: result)
  end
  #time-span has to be one of 1y, 2y, 5y, 6m, 3m, 1m, 1d
  def stock_history(conn, %{"abbreviation" => ab,  "time-span" => time}) do
    IO.puts(time)
    history = StockUtil.get_history(ab, time)
    render(conn, "stock_history.json", data: history)
  end

  def get_suggestions(conn, %{"input" => name}) do
    suggestions = StockUtil.search_suggestion(name)
    render(conn, "seggestion.json", suggestions: suggestions)
  end

  # time span has to be one of 1min, 5min, 15min, 30min, 60min
  def get_intraday_value(conn, %{"abbreviation" => ab, "time-span" => time}) do
    data = StockUtil.search_intraday(ab, time)
    render(conn, "intraday_value.json", data: data)
  end

end
