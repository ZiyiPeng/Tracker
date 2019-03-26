defmodule StockprojectWeb.PortfolioControllerTest do
  use StockprojectWeb.ConnCase

  alias Stockproject.Portfolios
  alias Stockproject.Portfolios.Portfolio

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:portfolio) do
    {:ok, portfolio} = Portfolios.create_portfolio(@create_attrs)
    portfolio
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all portfolio", %{conn: conn} do
      conn = get(conn, Routes.portfolio_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create portfolio" do
    test "renders portfolio when data is valid", %{conn: conn} do
      conn = post(conn, Routes.portfolio_path(conn, :create), portfolio: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.portfolio_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.portfolio_path(conn, :create), portfolio: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update portfolio" do
    setup [:create_portfolio]

    test "renders portfolio when data is valid", %{conn: conn, portfolio: %Portfolio{id: id} = portfolio} do
      conn = put(conn, Routes.portfolio_path(conn, :update, portfolio), portfolio: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.portfolio_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, portfolio: portfolio} do
      conn = put(conn, Routes.portfolio_path(conn, :update, portfolio), portfolio: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete portfolio" do
    setup [:create_portfolio]

    test "deletes chosen portfolio", %{conn: conn, portfolio: portfolio} do
      conn = delete(conn, Routes.portfolio_path(conn, :delete, portfolio))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.portfolio_path(conn, :show, portfolio))
      end
    end
  end

  defp create_portfolio(_) do
    portfolio = fixture(:portfolio)
    {:ok, portfolio: portfolio}
  end
end
