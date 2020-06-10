defmodule Nimble.Repo do
  use Ecto.Repo,
    otp_app: :nimble,
    adapter: Ecto.Adapters.Postgres
end
