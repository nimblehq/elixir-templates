defmodule Nimble.Phx.Gen.Template.AddonCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Nimble.Phx.Gen.Template.Addons
    end
  end

  setup do
    setup_test_app()

    {:ok, project: %Nimble.Phx.Gen.Template.Project{}}
  end

  def setup_test_app() do
    app_name = app_name()
    test_app_path = Path.join(test_apps_path(), app_name)

    create_new_project(test_app_path)
    inject_dependency(test_app_path)

    test_app_path
  end

  defp create_new_project(project_path) do
    shell_command("make create_project PROJECT_PATH=#{project_path}")
  end

  defp inject_dependency(project_path) do
    shell_command("make inject_dependency PROJECT_PATH=#{project_path}")
  end

  defp shell_command(cmd) do
    Mix.shell().cmd(cmd)
  end

  defp app_name do
    prefix = "test_app_"

    current_time = :os.system_time(:nanosecond) |> Integer.to_string()
    random = 1..10 |> Enum.shuffle() |> Enum.join()

    app_name = (current_time <> random) |> Base.encode64(padding: false) |> String.downcase()

    prefix <> app_name
  end

  defp test_apps_path do
    Path.expand("../../tmp", __DIR__)
  end
end
