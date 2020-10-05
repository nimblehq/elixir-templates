use Mix.Config

config :phoenix, :json_library, Jason

config :nimble_phx_gen_template,
  http_adapter: Nimble.Phx.Gen.Template.HttpClient.HttpAdapter,
  hex_client: Nimble.Phx.Gen.Template.Hex.HexClient,
  hex_package: Nimble.Phx.Gen.Template.Hex.Package

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
