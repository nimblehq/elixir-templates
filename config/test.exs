use Mix.Config

# Configure your database
config :nimble, Nimble.Repo,
  username: "postgres",
  password: "postgres",
  database: "nimble_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nimble, NimbleWeb.Endpoint,
  http: [port: 4002],
  server: true

config :nimble_web, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Wallaby
config :wallaby,
  otp_app: :nimble,
  chromedriver: [headless: System.get_env("CHROME_HEADLESS", "true") === "true"],
  screenshot_dir: "tmp/wallaby_screenshots",
  screenshot_on_failure: true
