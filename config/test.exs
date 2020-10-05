use Mix.Config

config :nimble_phx_gen_template,
  http_adapter: Nimble.Phx.Gen.Template.HttpClient.HttpAdapterMock,
  hex_client: Nimble.Phx.Gen.Template.Hex.HexClientMock,
  hex_package: Nimble.Phx.Gen.Template.Hex.PackageMock
