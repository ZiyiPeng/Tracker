defmodule StockprojectWeb.Router do
  use StockprojectWeb, :router
  alias StockprojectWeb.StockController
  alias StockprojectWeb.RecordController
  alias StockprojectWeb.PortfolioController
  alias StockprojectWeb.UserController
  alias StockprojectWeb.AuthController

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
    get "/stock_company", PageController, :index
    get "/portfolio", PageController, :index
    get "/stock", PageController, :index
    get "/create_user_form", PageController, :index


  end

  scope "/api" do
    pipe_through :api
    resources "/stocks", StockController, except: [:new, :edit]
    get "/stock_company", StockController, :look_up_company
    get "/stock_history", StockController, :stock_history
    get "/stock_search", StockController, :get_suggestions
    get "/stock_intraday", StockController, :get_intraday_value
    post "/prepare_stock", StockController, :prepare_stock


    resources "/users", UserController, except: [:new, :edit]
    resources "/portfolio", PortfolioController, except: [:new, :edit]
    get "/portfolio_value", PortfolioController, :get_portfolio_value
    get "/portfolio_history", PortfolioController, :get_historical_value
    get "/portfolio_stats", PortfolioController, :get_portfolio_stats

    resources "/records", RecordController, except: [:new, :edit]
    post "/auth", AuthController, :authenticate
  end

  # Other scopes may use custom stacks.
  # scope "/api", StockprojectWeb do
  #   pipe_through :api
  # end
end
