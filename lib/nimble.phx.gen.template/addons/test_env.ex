defmodule Nimble.Phx.Gen.Template.Addons.TestEnv do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
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
