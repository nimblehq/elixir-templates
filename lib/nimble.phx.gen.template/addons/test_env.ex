defmodule Nimble.Phx.Gen.Template.Addons.TestEnv do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_test_config
  end

  defp edit_test_config(project) do
    Generator.replace_content(
      "config/test.exs",
      """
        hostname: "localhost",
      """,
      """
        hostname: System.get_env("DB_HOST") || "localhost",
      """
    )

    project
  end
end
