defmodule StockprojectWeb.UserView do
  use StockprojectWeb, :view
  alias StockprojectWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.name,
      password_hash: user.password_hash,
      portfolio_id: user.portfolio.id
    }
  end
end
