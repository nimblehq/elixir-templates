defmodule NimbleTemplate.Addons.Phoenix.MixRelease do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> copy_files!()
    |> edit_files!()

    project
  end

  defp copy_files!(
         %Project{otp_app: otp_app, base_module: base_module, base_path: base_path} = project
       ) do
    Generator.copy_file!(
      [
        {:eex, "lib/otp_app/release_tasks.ex.eex", base_path <> "/release_tasks.ex"}
      ],
      otp_app: otp_app,
      base_module: base_module
    )

    project
  end

  defp edit_files!(%{otp_app: otp_app, web_module: web_module} = project) do
    Generator.delete_content!(
      "config/runtime.exs",
      """

      # ## Using releases
      #
      # If you use `mix release`, you need to explicitly enable the server
      # by passing the PHX_SERVER=true when you start it:
      #
      #     PHX_SERVER=true bin/#{otp_app} start
      #
      # Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
      # script that automatically sets the env var above.
      if System.get_env("PHX_SERVER") do
        config :#{otp_app}, #{web_module}.Endpoint, server: true
      end

      """
    )

    Generator.replace_content!(
      "config/runtime.exs",
      """
        config :#{otp_app}, #{web_module}.Endpoint,
      """,
      """
        config :#{otp_app}, #{web_module}.Endpoint,
          server: true,
      """
    )

    Generator.replace_content!(
      "config/runtime.exs",
      """
        host = System.get_env("PHX_HOST") || "example.com"
      """,
      """
        host =
          System.get_env("PHX_HOST") ||
            raise \"\"\"
            Environment variable PHX_HOST is missing.
            Set the Heroku endpoint to this variable.
            \"\"\"
      """
    )

    project
  end
end
