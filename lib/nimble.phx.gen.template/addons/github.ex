defmodule Nimble.Phx.Gen.Template.Addons.Github do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    otp_version: "23.0.2",
    elixir_version: "1.10.4"
  }

  @impl true
  def do_apply(%Project{} = project, opts) when is_map_key(opts, :github_template) do
    generate_github_template()

    project
  end

  @impl true
  def do_apply(%Project{} = project, opts) when is_map_key(opts, :github_action) do
    generate_github_action()

    project
  end

  def generate_github_template?(),
    do:
      Mix.shell().yes?(
        "\nDo you want to generate the .github/ISSUE_TEMPLATE and .github/PULL_REQUEST_TEMPLATE?"
      )

  def generate_github_action?(),
    do: Mix.shell().yes?("\nDo you want to generate the Github Action workflow?")

  defp generate_github_template() do
    files = [
      {:text, Path.join([".github", "ISSUE_TEMPLATE.md"]),
       Path.join([".github", "ISSUE_TEMPLATE.md"])},
      {:text, Path.join([".github", "PULL_REQUEST_TEMPLATE.md"]),
       Path.join([".github", "PULL_REQUEST_TEMPLATE.md"])}
    ]

    Generator.copy_file(files)
  end

  defp generate_github_action() do
    binding = [
      otp_version: @versions.otp_version,
      elixir_version: @versions.elixir_version
    ]

    files = [
      {:eex, Path.join([".github", "workflows", "test.yml"]),
       Path.join([".github", "workflows", "test.yml"])}
    ]

    Generator.copy_file(files, binding)
  end
end
