defmodule NimbleTemplate.Addons.MixRelease do
  @moduledoc false

  use NimbleTemplate.Addon

  @prod_secret_path "config/prod.secret.exs"

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_files()
    |> copy_files()
    |> delete_files()
  end

  defp edit_files(project) do
    project
    |> edit_config_prod
    |> edit_config_prod_secret
  end

  defp edit_config_prod(project) do
    Generator.delete_content(
      "config/prod.exs",
      """

      # Finally import the config/prod.secret.exs which loads secrets
      # and configuration from environment variables.
      import_config "prod.secret.exs"
      """
    )

    project
  end

  defp edit_config_prod_secret(%Project{otp_app: otp_app, web_module: web_module} = project) do
    Generator.delete_content(
      @prod_secret_path,
      """
      # In this file, we load production configuration and secrets
      # from environment variables. You can also hardcode secrets,
      # although such is generally not recommended and you have to
      # remember to add this file to your .gitignore.
      use Mix.Config

      """
    )

    Generator.replace_content(
      @prod_secret_path,
      """
        secret_key_base: secret_key_base

      # ## Using releases (Elixir v1.9+)
      #
      # If you are doing OTP releases, you need to instruct Phoenix
      # to start each relevant endpoint:
      #
      #     config :#{otp_app}, #{web_module}.Endpoint, server: true
      #
      # Then you can assemble a release by calling `mix release`.
      # See `mix help release` for more information.
      """,
      """
        secret_key_base: secret_key_base,
        server: true
      """
    )

    project
  end

  defp copy_files(
         %Project{otp_app: otp_app, base_module: base_module, base_path: base_path} = project
       ) do
    prod_secret_content =
      @prod_secret_path
      |> File.read!()
      |> remove_last_new_line()
      |> String.replace("\n  ", "\n    ")
      |> String.replace("\n\n", "\n\n  ")

    Generator.copy_file(
      [
        {:eex, "config/runtime.exs.eex", "config/runtime.exs"},
        {:eex, "lib/otp_app/release_tasks.ex.eex", base_path <> "/release_tasks.ex"}
      ],
      prod_secret_content: prod_secret_content,
      otp_app: otp_app,
      base_module: base_module
    )

    project
  end

  defp remove_last_new_line(content) do
    if String.ends_with?(content, "\n") do
      String.slice(content, 0..-2)
    else
      content
    end
  end

  defp delete_files(project) do
    File.rm!(@prod_secret_path)

    project
  end
end
