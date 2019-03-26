defmodule Stockproject.StocksTest do
  use Stockproject.DataCase

  alias Stockproject.Stocks

  describe "stocks" do
    alias Stockproject.Stocks.Stock

    @valid_attrs %{abbreviation: "some abbreviation", modified_date: "2010-04-17T14:00:00Z", name: "some name", risk: 120.5}
    @update_attrs %{abbreviation: "some updated abbreviation", modified_date: "2011-05-18T15:01:01Z", name: "some updated name", risk: 456.7}
    @invalid_attrs %{abbreviation: nil, modified_date: nil, name: nil, risk: nil}

    def stock_fixture(attrs \\ %{}) do
      {:ok, stock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stocks.create_stock()

      stock
    end

    test "list_stocks/0 returns all stocks" do
      stock = stock_fixture()
      assert Stocks.list_stocks() == [stock]
    end

    test "get_stock!/1 returns the stock with given id" do
      stock = stock_fixture()
      assert Stocks.get_stock!(stock.id) == stock
    end

    test "create_stock/1 with valid data creates a stock" do
      assert {:ok, %Stock{} = stock} = Stocks.create_stock(@valid_attrs)
      assert stock.abbreviation == "some abbreviation"
      assert stock.modified_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert stock.name == "some name"
      assert stock.risk == 120.5
    end

    test "create_stock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stocks.create_stock(@invalid_attrs)
    end

    test "update_stock/2 with valid data updates the stock" do
      stock = stock_fixture()
      assert {:ok, %Stock{} = stock} = Stocks.update_stock(stock, @update_attrs)
      assert stock.abbreviation == "some updated abbreviation"
      assert stock.modified_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert stock.name == "some updated name"
      assert stock.risk == 456.7
    end

    test "update_stock/2 with invalid data returns error changeset" do
      stock = stock_fixture()
      assert {:error, %Ecto.Changeset{}} = Stocks.update_stock(stock, @invalid_attrs)
      assert stock == Stocks.get_stock!(stock.id)
    end

    test "delete_stock/1 deletes the stock" do
      stock = stock_fixture()
      assert {:ok, %Stock{}} = Stocks.delete_stock(stock)
      assert_raise Ecto.NoResultsError, fn -> Stocks.get_stock!(stock.id) end
    end

    test "change_stock/1 returns a stock changeset" do
      stock = stock_fixture()
      assert %Ecto.Changeset{} = Stocks.change_stock(stock)
    end
  end
end
