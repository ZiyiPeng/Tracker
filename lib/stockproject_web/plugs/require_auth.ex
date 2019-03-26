#from Nat Tuck's lecture note
defmodule Stockproject.Plugs.RequireAuth do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    token = get_req_header(conn, "x-auth")
    IO.inspect(hd(token))
    case Phoenix.Token.verify(StockprojectWeb.Endpoint, "user_id", hd(token), max_age: 86400) do
      {:ok, user_id} ->
        assign(conn, :current_user, Stockproject.Users.get_user!(user_id))
      {:error, err} ->
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:unprocessable_entity, Jason.encode!(%{"error" => err}))
        |> halt()
    end
  end
end
