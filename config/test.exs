use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stockproject, StockprojectWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :stockproject, Stockproject.Repo,
  username: "project02",
  password: "qwer1234kad",
  database: "project02_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
