defmodule NimbleTemplate.GithubHelper do
  def host_on_github?(), do: Mix.shell().yes?("\nWill you host this project on Github?")

  def generate_github_template?(),
    do:
      Mix.shell().yes?(
        "\nDo you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?"
      )

  def generate_github_action?(),
    do: Mix.shell().yes?("\nDo you want to generate the Github Action workflow?")

  def generate_github_wiki?(),
    do:
      Mix.shell().yes?(
        "\nDo you want to publish a Github Wiki for this project? You'd need to manually create the first Github Wiki Page and set the GH_TOKEN and GH_EMAIL secret for this to properly function."
      )
end
