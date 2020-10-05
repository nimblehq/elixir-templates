use Mix.Config

config :nimble_phx_gen_template,
  http_adapter: Nimble.Phx.Gen.Template.HttpClient.HttpAdapter,
  hex_client: Nimble.Phx.Gen.Template.Hex.HexClient,
  hex_package: Nimble.Phx.Gen.Template.Hex.Package
