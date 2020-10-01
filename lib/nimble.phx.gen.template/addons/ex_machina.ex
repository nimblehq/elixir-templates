defmodule Nimble.Phx.Gen.Template.Addons.ExMachina do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    ex_machina: "~> 2.4"
  }

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files
    |> edit_files()
  end

  defp copy_files(%Project{base_module: base_module} = project) do
    Generator.copy_file([{:eex, "test/support/factory.ex.eex", "test/support/factory.ex"}],
      base_module: base_module
    )

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency
    |> edit_test_helper
    |> import_factory

    project
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency({:ex_machina, @versions.ex_machina, only: :test})

    project
  end

  defp edit_test_helper(%Project{} = project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """
      ExUnit.start()
      """,
      """
      {:ok, _} = Application.ensure_all_started(:ex_machina)

      ExUnit.start()
      """
    )

    project
  end

  defp import_factory(%Project{base_module: base_module, web_module: web_module} = project) do
    Generator.replace_content(
      "test/support/data_case.ex",
      """
            import #{base_module}.DataCase
      """,
      """
            import #{base_module}.DataCase
            import #{base_module}.Factory
      """
    )

    Generator.replace_content(
      "test/support/channel_case.ex",
      """
            import #{web_module}.ChannelCase
      """,
      """
            import #{web_module}.ChannelCase
            import #{base_module}.Factory
      """
    )

    Generator.replace_content(
      "test/support/conn_case.ex",
      """
            import #{web_module}.ConnCase
      """,
      """
            import #{web_module}.ConnCase
            import #{base_module}.Factory
      """
    )

    project
  end
end
