defmodule NimbleTemplate.Template do
  @moduledoc false

  alias NimbleTemplate.Mix.Template, as: MixTemplate
  alias NimbleTemplate.Phoenix.Template, as: PhoenixTemplate
  alias NimbleTemplate.Project

  def apply(%Project{mix_project?: true} = project) do
    MixTemplate.apply(project)

    fetch_and_install_dependencies()
  end

  def apply(%Project{} = project) do
    PhoenixTemplate.apply(project)

    fetch_and_install_dependencies()
  end

  def host_on_github?(), do: Mix.shell().yes?("\nWill you host this project on Github?")

  def generate_github_template?(),
    do:
      Mix.shell().yes?(
        "\nDo you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?"
      )

  def generate_github_action?(),
    do: Mix.shell().yes?("\nDo you want to generate the Github Action workflow?")

  def install_addon_prompt?(addon),
    do: Mix.shell().yes?("\nWould you like to add the #{addon} addon?")

  defp fetch_and_install_dependencies(),
    do:
      if(Mix.shell().yes?("\nFetch and install dependencies?"), do: Mix.shell().cmd("mix deps.get"))
end
