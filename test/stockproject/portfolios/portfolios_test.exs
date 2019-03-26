defmodule Stockproject.PortfoliosTest do
  use Stockproject.DataCase

  alias Stockproject.Portfolios

  describe "portfolio" do
    alias Stockproject.Portfolios.Portfolio

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def portfolio_fixture(attrs \\ %{}) do
      {:ok, portfolio} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Portfolios.create_portfolio()

      portfolio
    end

    test "list_portfolio/0 returns all portfolio" do
      portfolio = portfolio_fixture()
      assert Portfolios.list_portfolio() == [portfolio]
    end

    test "get_portfolio!/1 returns the portfolio with given id" do
      portfolio = portfolio_fixture()
      assert Portfolios.get_portfolio!(portfolio.id) == portfolio
    end

    test "create_portfolio/1 with valid data creates a portfolio" do
      assert {:ok, %Portfolio{} = portfolio} = Portfolios.create_portfolio(@valid_attrs)
      assert portfolio.name == "some name"
    end

    test "create_portfolio/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Portfolios.create_portfolio(@invalid_attrs)
    end

    test "update_portfolio/2 with valid data updates the portfolio" do
      portfolio = portfolio_fixture()
      assert {:ok, %Portfolio{} = portfolio} = Portfolios.update_portfolio(portfolio, @update_attrs)
      assert portfolio.name == "some updated name"
    end

    test "update_portfolio/2 with invalid data returns error changeset" do
      portfolio = portfolio_fixture()
      assert {:error, %Ecto.Changeset{}} = Portfolios.update_portfolio(portfolio, @invalid_attrs)
      assert portfolio == Portfolios.get_portfolio!(portfolio.id)
    end

    test "delete_portfolio/1 deletes the portfolio" do
      portfolio = portfolio_fixture()
      assert {:ok, %Portfolio{}} = Portfolios.delete_portfolio(portfolio)
      assert_raise Ecto.NoResultsError, fn -> Portfolios.get_portfolio!(portfolio.id) end
    end

    test "change_portfolio/1 returns a portfolio changeset" do
      portfolio = portfolio_fixture()
      assert %Ecto.Changeset{} = Portfolios.change_portfolio(portfolio)
    end
  end
end
