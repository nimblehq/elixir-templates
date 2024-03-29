defmodule NimbleTemplate.Addons.Mimic do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    edit_files!(project)
  end

  defp edit_files!(%Project{} = project) do
    project
    |> inject_mix_dependency!()
    |> edit_test_helper!()
    |> edit_case!()
  end

  defp inject_mix_dependency!(project) do
    Generator.inject_mix_dependency!({:mimic, latest_package_version(:mimic), only: :test})

    project
  end

  defp edit_test_helper!(project) do
    Generator.replace_content!(
      "test/test_helper.exs",
      """
      ExUnit.start()
      """,
      """
      {:ok, _} = Application.ensure_all_started(:mimic)

      ExUnit.start()
      """
    )

    project
  end

  defp edit_case!(%Project{mix_project?: false} = project) do
    Generator.inject_content!(
      "test/support/conn_case.ex",
      """
          quote do
      """,
      """
            use Mimic

      """
    )

    Generator.inject_content!(
      "test/support/data_case.ex",
      """
          quote do
      """,
      """
            use Mimic

      """
    )

    project
  end

  defp edit_case!(project) do
    project
  end
end
