defmodule NimbleTemplate.Templates.Template do
  @moduledoc false

  import NimbleTemplate.DependencyHelper

  alias NimbleTemplate.Addons.ExUnit
  alias NimbleTemplate.CredoHelper
  alias NimbleTemplate.Projects.Project
  alias NimbleTemplate.Templates.Mix.Template, as: MixTemplate
  alias NimbleTemplate.Templates.Phoenix.Template, as: PhoenixTemplate

  def apply(%Project{mix_project?: true} = project) do
    MixTemplate.apply(project)

    ExUnit.apply(project)

    post_apply(project)
  end

  def apply(%Project{mix_project?: false} = project) do
    PhoenixTemplate.apply(project)

    ExUnit.apply(project)

    post_apply(project)
  end

  defp post_apply(%Project{mix_project?: true} = project) do
    order_dependencies!()
    fetch_and_install_elixir_dependencies()
    suppress_necessary_credo_warnings(project)
    format_codebase()
  end

  defp post_apply(%Project{api_project?: true} = project) do
    order_dependencies!()
    fetch_and_install_elixir_dependencies()
    suppress_necessary_credo_warnings(project)
    format_codebase()
  end

  defp post_apply(%Project{web_project?: true} = project) do
    order_dependencies!()
    fetch_and_install_elixir_dependencies()
    fetch_and_install_node_dependencies()
    suppress_necessary_credo_warnings(project)
    format_codebase()
  end

  defp fetch_and_install_elixir_dependencies() do
    Mix.shell().cmd("MIX_ENV=dev mix do deps.get, deps.compile")
    Mix.shell().cmd("MIX_ENV=test mix do deps.get, deps.compile")
  end

  defp fetch_and_install_node_dependencies() do
    Mix.shell().cmd("npm install --prefix assets")
  end

  defp suppress_necessary_credo_warnings(%Project{
         base_module: base_module,
         base_path: base_path,
         web_path: web_path,
         web_test_path: web_test_path
       }) do
    Enum.each(
      [
        "lib/#{Macro.underscore(base_module)}.ex",
        "#{web_path}/controllers/page_controller.ex",
        "#{web_path}/telemetry.ex",
        "#{web_path}/views/error_view.ex",
        "#{web_path}/views/error_view.ex",
        "#{base_path}/release_tasks.ex"
      ],
      fn file_path ->
        CredoHelper.disable_rule(file_path, "CompassCredoPlugin.Check.DoSingleExpression")
      end
    )

    Enum.each(
      [
        "#{web_test_path}/views/api/error_view_test.exs",
        "#{web_test_path}/params/params_validator_test.exs"
      ],
      fn file_path ->
        CredoHelper.disable_rule(file_path, "CompassCredoPlugin.Check.SingleModuleFile")
      end
    )
  end

  defp format_codebase() do
    Mix.shell().cmd("mix codebase.fix")
  end
end
