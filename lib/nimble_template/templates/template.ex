defmodule NimbleTemplate.Templates.Template do
  @moduledoc false

  import NimbleTemplate.DependencyHelper

  alias NimbleTemplate.Templates.Mix.Template, as: MixTemplate
  alias NimbleTemplate.Templates.Phoenix.Template, as: PhoenixTemplate
  alias NimbleTemplate.Project

  def apply(%Project{mix_project?: true} = project) do
    MixTemplate.apply(project)

    post_apply(project)
  end

  def apply(%Project{mix_project?: false} = project) do
    PhoenixTemplate.apply(project)

    post_apply(project)
  end

  defp post_apply(%Project{mix_project?: true}) do
    order_dependencies!()
    fetch_and_install_elixir_dependencies()
    format_codebase()
  end

  defp post_apply(%Project{api_project?: true}) do
    order_dependencies!()
    fetch_and_install_elixir_dependencies()
    format_codebase()
  end

  defp post_apply(%Project{web_project?: true}) do
    order_dependencies!()
    fetch_and_install_elixir_dependencies()
    fetch_and_install_node_dependencies()
    format_codebase()
  end

  defp fetch_and_install_elixir_dependencies() do
    Mix.shell().cmd("MIX_ENV=develop mix do deps.get, deps.compile")
    Mix.shell().cmd("MIX_ENV=test mix do deps.get, deps.compile")
  end

  defp fetch_and_install_node_dependencies() do
    Mix.shell().cmd("npm install --prefix assets")
  end

  defp format_codebase() do
    Mix.shell().cmd("mix codebase.fix")
  end
end
