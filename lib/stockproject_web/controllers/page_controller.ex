defmodule StockprojectWeb.PageController do
  use StockprojectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
