defmodule StockprojectWeb.StockView do
  use StockprojectWeb, :view
  alias StockprojectWeb.StockView

  def render("index.json", %{stocks: stocks}) do
    %{data: render_many(stocks, StockView, "stock.json")}
  end

  def render("show.json", %{stock: stock}) do
    %{data: render_one(stock, StockView, "stock.json")}
  end

  def render("stock.json", %{stock: stock}) do
    %{id: stock.id,
      name: stock.name,
      abbreviation: stock.abbreviation,
      risk: stock.risk,
      modified_date: stock.modified_date}
  end
end
