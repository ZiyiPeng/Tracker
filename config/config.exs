# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stockproject,
  ecto_repos: [Stockproject.Repo]

# Configures the endpoint
config :stockproject, StockprojectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XcVm5Ms080lk3Np0ClC/t/wZp7SWLp150r1ah1sLzSmPUU4BAHJp38XMP7v40j93",
  render_errors: [view: StockprojectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Stockproject.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :stockproject, :iex_token, "pk_e65af52d92154877b9493a18603b3e96"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
