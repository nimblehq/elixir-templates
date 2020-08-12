import Config

config :nimble, Nimble.Repo,
  # ssl: true,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :nimble, NimbleWeb.Endpoint,
  http: [
    port: String.to_integer(System.fetch_env!("PORT")),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [
    host: System.fetch_env!("HOST"),
    port: String.to_integer(System.fetch_env!("PORT"))
  ],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  server: true
