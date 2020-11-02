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
  def do_apply(%Project{api_project?: api_project?} = project, opts)
      when is_map_key(opts, :github_action) do
    binding = [
      otp_version: @versions.otp_version,
      elixir_version: @versions.elixir_version,
      web_project?: !api_project?
    ]

    files = [
      {:eex, ".github/workflows/test.yml.eex", ".github/workflows/test.yml"}
    ]

    Generator.copy_file(files, binding)

    project
  end
end
