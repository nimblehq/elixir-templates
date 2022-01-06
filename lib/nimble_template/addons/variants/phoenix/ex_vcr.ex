defmodule NimbleTemplate.Addons.Phoenix.ExVCR do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @cassette_directory "test/support/fixtures/vcr_cassettes"

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_files()
    |> create_cassette_directory()
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency()
    |> edit_test_config()
    |> edit_case()

    project
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency({:exvcr, latest_package_version(:exvcr), only: :test})

    project
  end

  defp edit_test_config(project) do
    Generator.append_content(
      "config/test.exs",
      """

      # Configurations for ExVCR
      config :exvcr,
        vcr_cassette_library_dir: "#{@cassette_directory}",
        ignore_localhost: true
      """
    )

    project
  end

  defp edit_case(project) do
    Generator.inject_content(
      "test/support/channel_case.ex",
      """
          quote do
      """,
      """
            use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

      """
    )

    Generator.inject_content(
      "test/support/conn_case.ex",
      """
          quote do
      """,
      """
            use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

      """
    )

    Generator.inject_content(
      "test/support/data_case.ex",
      """
          quote do
      """,
      """
            use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

      """
    )

    Generator.inject_content(
      "test/support/view_case.ex",
      """
          quote do
      """,
      """
            use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

      """
    )

    project
  end

  defp create_cassette_directory(project) do
    Generator.make_directory(@cassette_directory)

    project
  end
end
