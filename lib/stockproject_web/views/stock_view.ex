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
      rate_of_return: stock.rate_of_return,
      beta: stock.beta,
      modified_date: stock.modified_date}
  end

#return company financial information
  def render("company.json", %{company: company}) do
    %{ ceo: company.ceo,
       company_name: company.company_name,
       description: company.description,
       sector: company.sector,
       symbol: company.symbol,
       website: company.website }
  end

  def render("stock_history.json", %{data: data}) do
    histories = Enum.map(data, fn x -> %{price: x.close, date: x.date} end)
    %{history: histories}
  end

  def render("seggestion.json", %{suggestions: suggestions}) do
    %{best_matches: suggestions}
  end

  def render("intraday_value.json", %{data: data}) do
    %{metadata: data.metadata, prices: data.prices}
  end

end
