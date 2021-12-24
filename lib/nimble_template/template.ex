defmodule NimbleTemplate.Template do
  @moduledoc false

  import NimbleTemplate.DependencyHelper

  alias NimbleTemplate.Mix.Template, as: MixTemplate
  alias NimbleTemplate.Phoenix.Template, as: PhoenixTemplate
  alias NimbleTemplate.Project

  def apply(%Project{mix_project?: true} = project) do
    MixTemplate.apply(project)

    post_apply(project)
  end

  def apply(%Project{mix_project?: false} = project) do
    PhoenixTemplate.apply(project)

    post_apply(project)
  end

  # TODO: move to GihubExtention after rebase
  def host_on_github?(), do: Mix.shell().yes?("\nWill you host this project on Github?")

  def generate_github_template?(),
      do: Mix.shell().yes?("\nDo you want to generate the Github Issue & Pull request templates?")

  def generate_github_workflows_readme?(),
      do: Mix.shell().yes?("\nDo you want to generate the .github/workflows/README file?")

  def generate_github_action_test?(),
      do: Mix.shell().yes?("\nDo you want to generate the Github Action workflows: Test?")

  def generate_github_action_deploy_heroku?(),
      do: Mix.shell().yes?("\nDo you want to generate the Github Action workflows: Deploy to Heroku?")

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
