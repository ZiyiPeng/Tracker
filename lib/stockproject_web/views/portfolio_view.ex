defmodule StockprojectWeb.PortfolioView do
  use StockprojectWeb, :view
  alias StockprojectWeb.PortfolioView
  alias StockprojectWeb.RecordView

  def render("index.json", %{portfolio: portfolio}) do
    %{data: render_many(portfolio, PortfolioView, "portfolio.json")}
  end

  def render("show.json", %{portfolio: portfolio}) do
    %{data: render_one(portfolio, PortfolioView, "portfolio.json")}
  end

  def render("portfolio.json", %{portfolio: portfolio}) do
    records = Enum.map(portfolio.records, fn x -> RecordView.render("record.json", %{record: x}) end)
    %{id: portfolio.id,
      name: portfolio.name,
      records: records}
  end

  def render("portfolio_value.json", %{value: value}) do
    %{value: value}
  end

  def render("portfolio_stats.json", %{data: data}) do
    %{composition: data.composition, risk: data.risk, beta: data.beta, rate_of_return: data.rate_of_return}
  end

  def render("portfolio_history.json", %{data: data}) do
    data
  end
end
