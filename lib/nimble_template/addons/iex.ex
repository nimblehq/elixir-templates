defmodule NimbleTemplate.Addons.Iex do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{otp_app: otp_app} = project, _opts) do
    Generator.copy_file([{:eex, ".iex.exs.eex", ".iex.exs"}], otp_app: otp_app)

    project
  end
end
