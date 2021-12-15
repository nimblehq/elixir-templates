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
  def do_apply(
        %Project{
          web_project?: web_project?,
          mix_project?: mix_project?,
          erlang_version: erlang_version,
          elixir_version: elixir_version
        } = project,
        opts
      )
      when is_map_key(opts, :github_wiki) do
    binding = [
      web_project?: web_project?,
      mix_project?: mix_project?,
      erlang_version: erlang_version,
      elixir_version: elixir_version
    ]

    template_workflow_path = ".github/workflows/publish_wiki.yml.eex"
    workflow_path = ".github/workflows/publish_wiki.yml"

    template_getting_started_path =
      if mix_project? do
        ".github/wiki/Getting-Started.md.mix.eex"
      else
        ".github/wiki/Getting-Started.md.eex"
      end

    getting_started_path = ".github/wiki/Getting-Started.md"

    homepage_path = ".github/wiki/Home.md"
    sidebar_path = ".github/wiki/_Sidebar.md"

    files = [
      {:text, template_workflow_path, workflow_path},
      {:text, homepage_path, homepage_path},
      {:eex, template_getting_started_path, getting_started_path},
      {:text, sidebar_path, sidebar_path}
    ]

    Generator.copy_file(files, binding)

    project
  end
end
