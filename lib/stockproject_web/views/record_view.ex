defmodule StockprojectWeb.RecordView do
  use StockprojectWeb, :view
  alias StockprojectWeb.RecordView

  def render("index.json", %{records: records}) do
    %{data: render_many(records, RecordView, "record.json")}
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, RecordView, "record.json")}
  end

  def render("record.json", %{record: record}) do
    %{id: record.id,
      amount: record.amount,
      quantity: record.quantity,
      purchased_price: record.purchased_price}
  end
end
