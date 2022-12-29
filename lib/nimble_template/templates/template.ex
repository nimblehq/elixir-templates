defmodule NimbleTemplate.Templates.Template do
  @moduledoc false

  import NimbleTemplate.{CredoHelper, DependencyHelper}

  alias NimbleTemplate.Addons.ExUnit
  alias NimbleTemplate.Projects.Project
  alias NimbleTemplate.Templates.Mix.Template, as: MixTemplate
  alias NimbleTemplate.Templates.Phoenix.Template, as: PhoenixTemplate

  def apply!(%Project{mix_project?: true} = project) do
    project
    |> MixTemplate.pre_apply()
    |> MixTemplate.apply!()

    ExUnit.apply!(project)

    post_apply!(project)
  end

  def apply!(%Project{mix_project?: false} = project) do
    project
    |> PhoenixTemplate.pre_apply()
    |> PhoenixTemplate.apply!()

    ExUnit.apply!(project)

    post_apply!(project)
  end

  defp post_apply!(%Project{mix_project?: true} = project) do
    order_dependencies!()
    install_elixir_dependencies()
    suppress_credo_warnings_for_base_project(project)
    format_codebase()
  end

  defp post_apply!(%Project{api_project?: true} = project) do
    order_dependencies!()
    install_elixir_dependencies()
    suppress_credo_warnings_for_phoenix_api_project(project)
    format_codebase()
  end

  defp post_apply!(%Project{web_project?: true} = project) do
    order_dependencies!()
    install_elixir_dependencies()
    install_node_dependencies()
    suppress_credo_warnings_for_phoenix_project(project)
    format_codebase()
  end

  defp install_elixir_dependencies() do
    Mix.shell().cmd("MIX_ENV=dev mix do deps.get, deps.compile")
    Mix.shell().cmd("MIX_ENV=test mix do deps.get, deps.compile")
  end

  defp install_node_dependencies(), do: Mix.shell().cmd("npm install --prefix assets")

  defp format_codebase(), do: Mix.shell().cmd("mix codebase.fix")
end
