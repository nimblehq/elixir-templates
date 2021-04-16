defmodule NimbleTemplate.Addons.Oban do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
    |> create_folders()
  end

  defp copy_files(%Project{base_module: base_module} = project) do
    migrate_version = Calendar.strftime(DateTime.utc_now(), "%Y%m%d%I%M%S")

    Generator.copy_file(
      [
        {:eex, "priv/repo/migrations/add_oban_jobs_table.exs.eex",
         "priv/repo/migrations/#{migrate_version}_add_oban_jobs_table.exs"}
      ],
      base_module: base_module
    )

    project
  end

  defp edit_files(project) do
    project
    |> inject_mix_dependency
    |> edit_application_ex
    |> edit_config
    |> edit_test_config

    project
  end

  defp create_folders(%Project{otp_app: otp_app} = project) do
    File.mkdir("lib/" <> Atom.to_string(otp_app) <> "_worker")

    project
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency({:oban, latest_package_version(:oban)})

    project
  end

  defp edit_application_ex(
         %Project{otp_app: otp_app, base_path: base_path, web_module: web_module} = project
       ) do
    Generator.replace_content(
      "#{base_path}/application.ex",
      """
            #{web_module}.Endpoint
      """,
      """
            #{web_module}.Endpoint,
            {Oban, oban_config()}
      """
    )

    Generator.inject_content(
      "#{base_path}/application.ex",
      """
        # Tell Phoenix to update the endpoint configuration
        # whenever the application is updated.
        def config_change(changed, _new, removed) do
          #{web_module}.Endpoint.config_change(changed, removed)
          :ok
        end
      """,
      """

        # Conditionally disable crontab, queues, or plugins here.
        defp oban_config do
          Application.get_env(:#{otp_app}, Oban)
        end
      """
    )

    project
  end

  defp edit_config(%Project{otp_app: otp_app, base_module: base_module} = project) do
    Generator.inject_content(
      "config/config.exs",
      """
      config :phoenix, :json_library, Jason
      """,
      """

      config :#{otp_app}, Oban,
        repo: #{base_module}.Repo,
        plugins: [Oban.Plugins.Pruner],
        queues: [default: 10]
      """
    )

    project
  end

  defp edit_test_config(%Project{otp_app: otp_app} = project) do
    Generator.inject_content(
      "config/test.exs",
      """
      config :logger, level: :warn
      """,
      """

      config :#{otp_app}, Oban, crontab: false, queues: false, plugins: false
      """
    )

    project
  end
end
