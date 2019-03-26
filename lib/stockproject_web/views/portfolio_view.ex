defmodule StockprojectWeb.PortfolioView do
  use StockprojectWeb, :view
  alias StockprojectWeb.PortfolioView

  def render("index.json", %{portfolio: portfolio}) do
    %{data: render_many(portfolio, PortfolioView, "portfolio.json")}
  end

  def render("show.json", %{portfolio: portfolio}) do
    %{data: render_one(portfolio, PortfolioView, "portfolio.json")}
  end

  def render("portfolio.json", %{portfolio: portfolio}) do
    %{id: portfolio.id,
      name: portfolio.name}
  end
end
