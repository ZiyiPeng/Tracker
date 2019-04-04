defmodule StockprojectWeb.Router do
  use StockprojectWeb, :router
  alias StockprojectWeb.StockController
  alias StockprojectWeb.RecordController
  # alias StockprojectWeb.PortfolioController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StockprojectWeb do
    pipe_through :browser
    get "/", PageController, :index
    resources "/stocks", StockController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/portfolios", PortfolioController, except: [:new, :edit]
    resources "/records", RecordController, except: [:new, :edit]
  end

  scope "/api" do
    pipe_through :api
    get "/stock_company", StockController, :look_up_company
    get "/stock_history", StockController, :stock_history
    get "/stock_search", StockController, :get_suggestions
    get "/stock_intraday", StockController, :get_intraday_value
    get "/portfolio_value", PortfolioController, :get_portfolio_value
    get "/portfolio_history", PortfolioController, :get_historical_value
    get "/portfolio_stats", PortfolioController, :get_portfolio_stats
    post "/auth", AuthController, :authenticate
  end

  # Other scopes may use custom stacks.
  # scope "/api", StockprojectWeb do
  #   pipe_through :api
  # end
end
