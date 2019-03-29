defmodule StockprojectWeb.RecordView do
  use StockprojectWeb, :view
  alias StockprojectWeb.RecordView
  alias Stockproject.Stocks

  def render("index.json", %{records: records}) do
    %{data: render_many(records, RecordView, "record.json")}
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, RecordView, "record.json")}
  end

  def render("record.json", %{record: record}) do
    stock = Stocks.get_stock!(record.stock_id)
    stock = StockprojectWeb.StockView.render("stock.json", %{stock: stock})
    %{id: record.id,
      amount: record.amount,
      quantity: record.quantity,
      purchased_price: record.purchased_price,
      stock: stock
    }
  end
end
