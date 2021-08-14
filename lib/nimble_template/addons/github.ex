defmodule NimbleTemplate.Addons.Github do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, opts) when is_map_key(opts, :github_template) do
    files = [
      {:text, Path.join([".github", "ISSUE_TEMPLATE.md"]),
       Path.join([".github", "ISSUE_TEMPLATE.md"])},
      {:text, Path.join([".github", "PULL_REQUEST_TEMPLATE.md"]),
       Path.join([".github", "PULL_REQUEST_TEMPLATE.md"])},
      {:text, Path.join([".github", "PULL_REQUEST_TEMPLATE", "RELEASE_TEMPLATE.md"]),
       Path.join([".github", "PULL_REQUEST_TEMPLATE", "RELEASE_TEMPLATE.md"])}
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
      when is_map_key(opts, :github_action_test) do
    binding = [
      erlang_version: erlang_version,
      elixir_version: elixir_version,
      node_version: node_version,
      web_project?: web_project?
    ]

    template_file_path =
      if mix_project? do
        ".github/workflows/test.yml.mix.eex"
      else
        ".github/workflows/test.yml.eex"
      end

    files = [
      {:eex, template_file_path, ".github/workflows/test.yml"}
    ]

    Generator.copy_file(files, binding)

    project
  end

  @impl true
  def do_apply(%Project{} = project, opts) when is_map_key(opts, :github_workflows_readme) do
    Generator.copy_file([
      {:eex, ".github/workflows/README.md", ".github/workflows/README.md"}
    ])

    project
  end

  @impl true
  def do_apply(%Project{} = project, opts) when opts.github_action_deploy_heroku do
    Generator.copy_file([
      {:eex, ".github/workflows/deploy_heroku.yml.eex", ".github/workflows/deploy_heroku.yml"}
    ])

    project
  end

  @impl true
  def do_apply(%Project{} = project, opts) when not opts.github_action_deploy_heroku do
    project
  end
end
