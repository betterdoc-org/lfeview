# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lfeview,
  ecto_repos: [Lfeview.Repo]

# Configures the endpoint
config :lfeview, LfeviewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xqsbDgcIwJ+yx19C6TuXzn2TsV3SnnKadlEdGGHqfPxgNZ0b+rT6PMLW8/tJjLv/",
  render_errors: [view: LfeviewWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lfeview.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "b1E+YFNSBM3u0vUiGvYmRwlFATVJMmj+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
