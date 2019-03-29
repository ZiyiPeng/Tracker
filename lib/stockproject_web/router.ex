defmodule StockprojectWeb.Router do
  use StockprojectWeb, :router

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
    resources "/stocks", StockController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/portfolio", PortfolioController, except: [:new, :edit]
    resources "/records", RecordController, except: [:new, :edit]
    get "/", PageController, :index
  end

  scope "/api" do
    pipe_through :api
    resources "/stocks", StockController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/portfolio", PortfolioController, except: [:new, :edit]
    resources "/records", RecordController, except: [:new, :edit]
    post "/auth", AuthController, :authenticate
  end

  # Other scopes may use custom stacks.
  # scope "/api", StockprojectWeb do
  #   pipe_through :api
  # end
end
