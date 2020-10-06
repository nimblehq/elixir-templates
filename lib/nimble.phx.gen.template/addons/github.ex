defmodule Nimble.Phx.Gen.Template.Addons.Github do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    otp_version: "23.0.2",
    elixir_version: "1.10.4"
  }

  @impl true
  def do_apply(%Project{} = project, opts) when is_map_key(opts, :github_template) do
    files = [
      {:text, Path.join([".github", "ISSUE_TEMPLATE.md"]),
       Path.join([".github", "ISSUE_TEMPLATE.md"])},
      {:text, Path.join([".github", "PULL_REQUEST_TEMPLATE.md"]),
       Path.join([".github", "PULL_REQUEST_TEMPLATE.md"])}
    ]

    Generator.copy_file(files)

    project
  end

  @impl true
  def do_apply(%Project{} = project, opts) when is_map_key(opts, :github_action) do
    binding = [
      otp_version: @versions.otp_version,
      elixir_version: @versions.elixir_version
    ]

    files = [
      {:eex, github_action_template_path(project),
       Path.join([".github", "workflows", "test.yml"])}
    ]

    Generator.copy_file(files, binding)

    project
  end

  def github_action_template_path(%Project{api_project?: true}),
    do: Path.join(["variants", "api", ".github", "workflows", "test.yml.eex"])

  def github_action_template_path(%Project{api_project?: false}),
    do: Path.join(["variants", "web", ".github", "workflows", "test.yml.eex"])
end
