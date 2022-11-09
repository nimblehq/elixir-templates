import Config

config :phoenix, :json_library, Jason

config :nimble_template, hex_package_resource: NimbleTemplate.Hex.Package

import_config "#{config_env()}.exs"
