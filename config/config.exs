import Config

config :phoenix, :json_library, Jason

config :nimble_template, hex_package_resource: NimbleTemplate.Hex.Package

if File.exists?("config/#{config_env()}.exs") do
  import_config "#{config_env()}.exs"
end
