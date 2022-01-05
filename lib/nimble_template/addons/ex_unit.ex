defmodule NimbleTemplate.Addons.ExUnit do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts), do: edit_test_helper(project)

  defp edit_test_helper(%Project{} = project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """
      ExUnit.start()
      """,
      """
      ExUnit.start(capture_log: true)
      """
    )

    project
  end
end
