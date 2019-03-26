defmodule Stockproject.Repo do
  use Ecto.Repo,
    otp_app: :stockproject,
    adapter: Ecto.Adapters.Postgres
end
