defmodule NimbleTemplate.Addons.Phoenix.MixRelease do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()

    project
  end

  defp copy_files(
         %Project{otp_app: otp_app, base_module: base_module, base_path: base_path} = project
       ) do
    Generator.copy_file(
      [
        {:eex, "lib/otp_app/release_tasks.ex.eex", base_path <> "/release_tasks.ex"}
      ],
      otp_app: otp_app,
      base_module: base_module
    )

    project
  end

  defp edit_files(%{otp_app: otp_app, web_module: web_module} = project) do
    Generator.delete_content(
      "config/runtime.exs",
      """
      # Start the phoenix server if environment is set and running in a release
      if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
        config :#{otp_app}, #{web_module}.Endpoint, server: true
      end

      """
    )

    Generator.delete_content(
      "config/runtime.exs",
      """

        # ## Using releases
        #
        # If you are doing OTP releases, you need to instruct Phoenix
        # to start each relevant endpoint:
        #
        #     config :#{otp_app}, #{web_module}.Endpoint, server: true
        #
        # Then you can assemble a release by calling `mix release`.
        # See `mix help release` for more information.
      """
    )

    Generator.replace_content(
      "config/runtime.exs",
      """
        config :#{otp_app}, #{web_module}.Endpoint,
      """,
      """
        config :#{otp_app}, #{web_module}.Endpoint,
          server: true,
      """
    )

    project
  end
end
