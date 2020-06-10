# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nimble,
  ecto_repos: [Nimble.Repo]

# Configures the endpoint
config :nimble, NimbleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XwwgVZGbTA34x8PwPgeccGQRXR8r7YENJJG+owqOF3U87sc9aYOGcN0FPtrG+8Jf",
  render_errors: [view: NimbleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nimble.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "d45MiqmM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
