defmodule NimbleTemplate.Addons.Github do
  @moduledoc false

  use NimbleTemplate.Addon

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
  def do_apply(
        %Project{
          web_project?: web_project?,
          mix_project?: mix_project?,
          erlang_version: erlang_version,
          elixir_version: elixir_version,
          node_version: node_version
        } = project,
        opts
      )
      when is_map_key(opts, :github_action) do
    binding = [
      erlang_version: erlang_version,
      elixir_version: elixir_version,
      node_version: node_version,
      web_project?: web_project?
    ]

    files =
      [{:text, ".github/workflows/README.md", ".github/workflows/README.md"}] ++
        if mix_project? do
          [
            {:eex, ".github/workflows/test.yml.mix.eex", ".github/workflows/test.yml"},
            {:eex, ".github/workflows/deploy_heroku.yml.mix.eex",
             ".github/workflows/deploy_heroku.yml"}
          ]
        else
          [
            {:eex, ".github/workflows/test.yml.eex", ".github/workflows/test.yml"},
            {:eex, ".github/workflows/deploy_heroku.yml.eex", ".github/workflows/deploy_heroku.yml"}
          ]
        end

    Generator.copy_file(files, binding)

    project
  end
end
