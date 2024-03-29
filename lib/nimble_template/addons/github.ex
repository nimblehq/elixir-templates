defmodule NimbleTemplate.Addons.Github do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, %{github_template: true}) do
    files = [
      {:text, Path.join([".github", "ISSUE_TEMPLATE.md"]),
       Path.join([".github", "ISSUE_TEMPLATE.md"])},
      {:text, Path.join([".github", "PULL_REQUEST_TEMPLATE.md"]),
       Path.join([".github", "PULL_REQUEST_TEMPLATE.md"])},
      {:text, Path.join([".github", "PULL_REQUEST_TEMPLATE", "RELEASE_TEMPLATE.md"]),
       Path.join([".github", "PULL_REQUEST_TEMPLATE", "RELEASE_TEMPLATE.md"])}
    ]

    Generator.copy_file!(files)

    project
  end

  @impl true
  def do_apply!(
        %Project{
          web_project?: web_project?,
          mix_project?: mix_project?,
          erlang_version: erlang_version,
          elixir_version: elixir_version
        } = project,
        %{github_action_test: true}
      ) do
    binding = [
      erlang_version: erlang_version,
      elixir_version: elixir_version,
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

    Generator.copy_file!(files, binding)

    project
  end

  @impl true
  def do_apply!(
        %Project{} = project,
        %{
          github_workflows_readme: true,
          with_test_workflow?: with_test_workflow?,
          with_github_wiki?: with_github_wiki?,
          with_deploy_to_heroku_workflow?: with_deploy_to_heroku_workflow?
        }
      ) do
    Generator.copy_file!(
      [
        {:eex, ".github/workflows/README.md.eex", ".github/workflows/README.md"}
      ],
      with_test_workflow?: with_test_workflow?,
      with_github_wiki?: with_github_wiki?,
      with_deploy_to_heroku_workflow?: with_deploy_to_heroku_workflow?
    )

    project
  end

  @impl true
  def do_apply!(
        %Project{mix_project?: false, otp_app: otp_app, web_module: web_module} = project,
        %{
          github_action_deploy_heroku: true
        }
      ) do
    Generator.copy_file!([
      {:eex, ".github/workflows/deploy_heroku.yml", ".github/workflows/deploy_heroku.yml"}
    ])

    Generator.replace_content!("config/runtime.exs", "# ssl: true,", "ssl: true,")

    Generator.replace_content!(
      "config/runtime.exs",
      "url: [host: host,",
      "url: [scheme: \"https\", host: host,"
    )

    Generator.append_content!(
      "config/prod.exs",
      """
      config :#{otp_app}, #{web_module}.Endpoint,
        force_ssl: [rewrite_on: [:x_forwarded_proto]]
      """
    )

    project
  end

  @impl true
  def do_apply!(%Project{} = project, %{github_wiki: true}) do
    project
    |> copy_wiki_files!()
    |> append_wiki_into_readme!()
  end

  defp copy_wiki_files!(
         %Project{
           mix_project?: true,
           erlang_version: erlang_version,
           elixir_version: elixir_version
         } = project
       ) do
    binding = [
      erlang_version: erlang_version,
      elixir_version: elixir_version
    ]

    publish_wiki_workflow_path = ".github/workflows/publish_wiki.yml"
    template_getting_started_path = ".github/wiki/Getting-Started.md.mix.eex"
    homepage_path = ".github/wiki/Home.md"
    sidebar_path = ".github/wiki/_Sidebar.md.mix"

    files = [
      {:text, publish_wiki_workflow_path, publish_wiki_workflow_path},
      {:text, homepage_path, homepage_path},
      {:eex, template_getting_started_path, ".github/wiki/Getting-Started.md"},
      {:text, sidebar_path, ".github/wiki/_Sidebar.md"}
    ]

    Generator.copy_file!(files, binding)

    project
  end

  defp copy_wiki_files!(
         %Project{
           web_project?: web_project?,
           mix_project?: false,
           erlang_version: erlang_version,
           elixir_version: elixir_version,
           node_asdf_version: node_asdf_version
         } = project
       ) do
    binding = [
      web_project?: web_project?,
      erlang_version: erlang_version,
      elixir_version: elixir_version,
      node_asdf_version: node_asdf_version
    ]

    publish_wiki_workflow_path = ".github/workflows/publish_wiki.yml"
    template_getting_started_path = ".github/wiki/Getting-Started.md.eex"
    homepage_path = ".github/wiki/Home.md"
    sidebar_path = ".github/wiki/_Sidebar.md"
    application_status_path = ".github/wiki/Application-Status.md"
    environment_variables_path = ".github/wiki/Environment-Variables.md.eex"

    files = [
      {:text, publish_wiki_workflow_path, publish_wiki_workflow_path},
      {:text, homepage_path, homepage_path},
      {:eex, template_getting_started_path, ".github/wiki/Getting-Started.md"},
      {:text, sidebar_path, sidebar_path},
      {:text, application_status_path, application_status_path},
      {:eex, environment_variables_path, ".github/wiki/Environment-Variables.md"}
    ]

    Generator.copy_file!(files, binding)

    project
  end

  defp append_wiki_into_readme!(project) do
    Generator.append_content!(
      "README.md",
      """

      ## Project documentation

      Most of the documentation is located in the `.github/wiki` directory, which is published to the [project's Github wiki](https://github.com/[REPO]/wiki).
      """
    )

    project
  end
end
