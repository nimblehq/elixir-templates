defmodule NimbleTemplate.Template do
  @moduledoc false

  import NimbleTemplate.DependencyHelper

  alias NimbleTemplate.Mix.Template, as: MixTemplate
  alias NimbleTemplate.Phoenix.Template, as: PhoenixTemplate
  alias NimbleTemplate.Project

  def apply(%Project{mix_project?: true} = project) do
    MixTemplate.apply(project)

    order_dependencies!()
    fetch_and_install_elixir_dependencies()
  end

  def apply(%Project{api_project?: true} = project) do
    PhoenixTemplate.apply(project)

    order_dependencies!()
    fetch_and_install_elixir_dependencies()
  end

  def apply(%Project{web_project?: true} = project) do
    PhoenixTemplate.apply(project)

    order_dependencies!()
    fetch_and_install_elixir_dependencies()
    fetch_and_install_node_dependencies()
    run_prettier()
  end

  defp fetch_and_install_elixir_dependencies() do
    Mix.shell().cmd("MIX_ENV=develop mix do deps.get, deps.compile")
    Mix.shell().cmd("MIX_ENV=test mix do deps.get, deps.compile")
  end

  defp fetch_and_install_node_dependencies() do
    Mix.shell().cmd("npm install --prefix assets")
  end

  defp run_prettier() do
    Mix.shell().cmd("mix prettier.fix")
  end
end
