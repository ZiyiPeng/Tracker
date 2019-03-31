defmodule StockprojectWeb.PortfolioController do
  use StockprojectWeb, :controller

  alias Stockproject.Portfolios
  alias Stockproject.Portfolios.Portfolio

  action_fallback StockprojectWeb.FallbackController

  def index(conn, _params) do
    portfolio = Portfolios.list_portfolio()
    render(conn, "index.json", portfolio: portfolio)
  end

  def create(conn, %{"portfolio" => portfolio_params}) do
    with {:ok, %Portfolio{} = portfolio} <- Portfolios.create_portfolio(portfolio_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.portfolio_path(conn, :show, portfolio))
      |> render("show.json", portfolio: portfolio)
    end
  end

  def show(conn, %{"id" => id}) do
    portfolio = Portfolios.get_portfolio(id)
    render(conn, "show.json", portfolio: portfolio)
  end

  def update(conn, %{"id" => id, "portfolio" => portfolio_params}) do
    portfolio = Portfolios.get_portfolio!(id)

    with {:ok, %Portfolio{} = portfolio} <- Portfolios.update_portfolio(portfolio, portfolio_params) do
      render(conn, "show.json", portfolio: portfolio)
    end
  end

  def delete(conn, %{"id" => id}) do
    portfolio = Portfolios.get_portfolio!(id)

    with {:ok, %Portfolio{}} <- Portfolios.delete_portfolio(portfolio) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_portfolio_value(conn, %{"id" => id}) do
    value = PortfolioUtil.calc_portfolio_value(id)
    render(conn, "portfolio_value.json", value: value)
  end

  def get_portfolio_stats(conn, %{"id" => id}) do
    data = PortfolioUtil.calc_portfolio_stats(id)
    render(conn, "portfolio_stats.json", data: data)
  end

  def get_historical_value(conn, %{"id" => id}) do
    #[%{date, value}]
    data = PortfolioUtil.calc_historial_values(id)
    render(conn, "portfolio_history.json", data: data)
  end
end
