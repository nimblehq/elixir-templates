defmodule NimbleTemplate.Addons.GithubTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2 with github_template option" do
    test "copies the .github/ISSUE_TEMPLATE.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_template: true})

        assert_file(".github/ISSUE_TEMPLATE.md")
      end)
    end

    test "copies the .github/PULL_REQUEST_TEMPLATE.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_template: true})

        assert_file(".github/PULL_REQUEST_TEMPLATE.md")
      end)
    end

    test "copies the .github/PULL_REQUEST_TEMPLATE/RELEASE_TEMPLATE.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_template: true})

        assert_file(".github/PULL_REQUEST_TEMPLATE/RELEASE_TEMPLATE.md")
      end)
    end
  end

  describe "#apply/2 with mix_project and github_template option" do
    @describetag mix_project?: true

    test "copies the .github/ISSUE_TEMPLATE.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_template: true})

        assert_file(".github/ISSUE_TEMPLATE.md")
      end)
    end

    test "copies the .github/PULL_REQUEST_TEMPLATE.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_template: true})

        assert_file(".github/PULL_REQUEST_TEMPLATE.md")
      end)
    end

    test "copies the .github/PULL_REQUEST_TEMPLATE/RELEASE_TEMPLATE.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_template: true})

        assert_file(".github/PULL_REQUEST_TEMPLATE/RELEASE_TEMPLATE.md")
      end)
    end
  end

  describe "#apply/2 with github_workflows_readme option" do
    test "copies the .github/workflows/README.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{
          github_workflows_readme: true,
          with_test_workflow?: true,
          with_deploy_to_heroku_workflow?: true
        })

        assert_file(".github/workflows/README.md", fn file ->
          assert file =~ "- Test"

          assert file =~ "- [Deploy to Heroku](#deploy-to-heroku-workflow-usage-instruction)"
          assert file =~ "## Deploy to Heroku Workflow usage instruction"
        end)
      end)
    end

    test "does NOT generate the Test section given with_test_workflow? is false", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{
          github_workflows_readme: true,
          with_test_workflow?: false,
          with_deploy_to_heroku_workflow?: true
        })

        assert_file(".github/workflows/README.md", fn file ->
          refute file =~ "- Test"

          assert file =~ "- [Deploy to Heroku](#deploy-to-heroku-workflow-usage-instruction)"
          assert file =~ "## Deploy to Heroku Workflow usage instruction"
        end)
      end)
    end

    test "does NOT generate the Deploy to Heroku section given with_deploy_to_heroku_workflow? is false",
         %{
           project: project,
           test_project_path: test_project_path
         } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{
          github_workflows_readme: true,
          with_test_workflow?: true,
          with_deploy_to_heroku_workflow?: false
        })

        assert_file(".github/workflows/README.md", fn file ->
          assert file =~ "- Test"

          refute file =~ "- [Deploy to Heroku](#deploy-to-heroku-workflow-usage-instruction)"
          refute file =~ "## Deploy to Heroku Workflow usage instruction"
        end)
      end)
    end

    test "does NOT generate the Test and Deploy to Heroku sections given with_test_workflow? and with_deploy_to_heroku_workflow? are false",
         %{
           project: project,
           test_project_path: test_project_path
         } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{
          github_workflows_readme: true,
          with_test_workflow?: false,
          with_deploy_to_heroku_workflow?: false
        })

        assert_file(".github/workflows/README.md", fn file ->
          refute file =~ "- Test"

          refute file =~ "- [Deploy to Heroku](#deploy-to-heroku-workflow-usage-instruction)"
          refute file =~ "## Deploy to Heroku Workflow usage instruction"
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project and github_workflows_readme option" do
    @describetag mix_project?: true

    test "copies the .github/workflows/README.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{
          github_workflows_readme: true,
          with_test_workflow?: true,
          with_deploy_to_heroku_workflow?: false
        })

        assert_file(".github/workflows/README.md", fn file ->
          assert file =~ "- Test"

          refute file =~ "- [Deploy to Heroku](#deploy-to-heroku-workflow-usage-instruction)"
          refute file =~ "## Deploy to Heroku Workflow usage instruction"
        end)
      end)
    end

    test "does NOT generate the Test section given with_test_workflow? is false", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{
          github_workflows_readme: true,
          with_test_workflow?: false,
          with_deploy_to_heroku_workflow?: false
        })

        assert_file(".github/workflows/README.md", fn file ->
          refute file =~ "- Test"

          refute file =~ "- [Deploy to Heroku](#deploy-to-heroku-workflow-usage-instruction)"
          refute file =~ "## Deploy to Heroku Workflow usage instruction"
        end)
      end)
    end
  end

  describe "#apply/2 with api_project and github_action_test option" do
    test "does NOT include the npm setting", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_test: true})

        assert_file(".github/workflows/test.yml", fn file ->
          refute file =~ "assets/node_modules"
          refute file =~ "npm --prefix assets install"
          refute file =~ "mix assets.deploy"
          refute file =~ "wallaby_screenshots"
        end)
      end)
    end
  end

  describe "#apply/2 with web_project and github_action_test option" do
    test "includes the npm setting", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_test: true})

        assert_file(".github/workflows/test.yml", fn file ->
          assert file =~ "assets/node_modules"
          assert file =~ "npm --prefix assets install"
          assert file =~ "mix assets.deploy"
          assert file =~ "wallaby_screenshots"
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project and github_action_test option" do
    @describetag mix_project?: true

    test "does NOT include database setting", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_test: true})

        assert_file(".github/workflows/test.yml", fn file ->
          refute file =~ "postgres"
          refute file =~ "ecto.create"
          refute file =~ "ecto.migrate"
        end)
      end)
    end

    test "does NOT include the npm setting", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_test: true})

        assert_file(".github/workflows/test.yml", fn file ->
          refute file =~ "assets/node_modules"
          refute file =~ "npm --prefix assets install"
          refute file =~ "mix assets.deploy"
          refute file =~ "wallaby_screenshots"
        end)
      end)
    end
  end

  describe "#apply/2 with api_project and github_action_deploy_heroku option" do
    test "copies the .github/workflows/deploy_heroku.yml file", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_deploy_heroku: true})

        assert_file(".github/workflows/deploy_heroku.yml")
      end)
    end

    test "adjusts config/runtime.exs ", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_deploy_heroku: true})

        assert_file("config/runtime.exs", fn file ->
          assert file =~ "url: [scheme: \"https\", host: host,"

          assert file =~ """
                   config :nimble_template, NimbleTemplate.Repo,
                     ssl: true,
                 """
        end)
      end)
    end

    test "adds force_ssl config into config/prod.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_deploy_heroku: true})

        assert_file("config/prod.exs", fn file ->
          assert file =~ """
                 config :nimble_template, NimbleTemplateWeb.Endpoint,
                   force_ssl: [rewrite_on: [:x_forwarded_proto]]
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with web_project and github_action_deploy_heroku option" do
    test "copies the .github/workflows/deploy_heroku.yml file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action_deploy_heroku: true})

        assert_file(".github/workflows/deploy_heroku.yml")
      end)
    end
  end

  describe "#apply/2 with mix_project and github_action_deploy_heroku option" do
    @describetag mix_project?: true

    test "raises FunctionClauseError exception", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        assert_raise FunctionClauseError, fn ->
          Addons.Github.apply(project, %{github_action_deploy_heroku: true})
        end
      end)
    end
  end

  describe "#apply/2 with github_wiki option" do
    test "copies the .github/workflows/publish_wiki.yml and Github Wiki files", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_wiki: true})

        assert_file(".github/workflows/publish_wiki.yml")

        assert_file(".github/wiki/Getting-Started.md", fn file ->
          assert file =~ "Erlang 26.0.1"
          assert file =~ "Elixir 1.15.6"

          assert file =~ "Node 1.18.6"
          assert file =~ "- [asdf-node](https://github.com/asdf-vm/asdf-node)"

          assert file =~ """
                 - Install Node dependencies:

                   ```sh
                   npm install --prefix assets
                   ```
                 """

          assert file =~ """
                 - Start the Phoenix app

                   ```sh
                   iex -S mix phx.server
                   ```
                 """
        end)

        assert_file(".github/wiki/Home.md", fn file ->
          assert file =~ "Insert information about your project here!"
        end)

        assert_file(".github/wiki/Application-Status.md")

        assert_file(".github/wiki/_Sidebar.md", fn file ->
          assert file =~ """
                 ## Table of Contents

                 - [[Home]]
                 - [[Getting Started]]

                 ## Infrastructure

                 - [[Application Status]]
                 - [[Environment Variables]]
                 """
        end)
      end)
    end

    test "mentions Wiki in README.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_wiki: true})

        assert_file("README.md", fn file ->
          assert file =~ """
                 ## Project documentation

                 Most of the documentation is located in the `.github/wiki` directory, which is published to the [project's Github wiki](https://github.com/[REPO]/wiki).
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with api_project and github_wiki option" do
    test "copies the .github/workflows/publish_wiki.yml and Github Wiki files", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_wiki: true})

        assert_file(".github/workflows/publish_wiki.yml")

        assert_file(".github/wiki/Getting-Started.md", fn file ->
          assert file =~ "Erlang 26.0.1"
          assert file =~ "Elixir 1.15.6"

          refute file =~ "Node 1.18.6"
          refute file =~ "- [asdf-node](https://github.com/asdf-vm/asdf-node)"

          refute file =~ """
                      - Install Node dependencies:

                        ```sh
                        npm install --prefix assets
                        ```
                 """

          assert file =~ """
                 - Start the Phoenix app

                   ```sh
                   iex -S mix phx.server
                   ```
                 """
        end)

        assert_file(".github/wiki/Home.md", fn file ->
          assert file =~ "Insert information about your project here!"
        end)

        assert_file(".github/wiki/Application-Status.md")
        assert_file(".github/wiki/Environment-Variables.md")

        assert_file(".github/wiki/_Sidebar.md", fn file ->
          assert file =~ """
                 ## Table of Contents

                 - [[Home]]
                 - [[Getting Started]]

                 ## Infrastructure

                 - [[Application Status]]
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project and github_wiki option" do
    @describetag mix_project?: true

    test "copies the .github/workflows/publish_wiki.yml and Github Wiki files", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_wiki: true})

        assert_file(".github/workflows/publish_wiki.yml")

        assert_file(".github/wiki/Getting-Started.md", fn file ->
          assert file =~ "Erlang 26.0.1"
          assert file =~ "Elixir 1.15.6"

          refute file =~ "Node 1.18.6"
          refute file =~ "- [asdf-node](https://github.com/asdf-vm/asdf-node)"

          refute file =~ """
                      - Install Node dependencies:

                        ```sh
                        npm install --prefix assets
                        ```
                 """

          refute file =~ """
                 - Start the Phoenix app

                   ```sh
                   iex -S mix phx.server
                   ```
                 """
        end)

        assert_file(".github/wiki/Home.md", fn file ->
          assert file =~ "Insert information about your project here!"
        end)

        refute_file(".github/wiki/Application-Status.md")

        assert_file(".github/wiki/_Sidebar.md", fn file ->
          assert file =~ """
                 ## Table of Contents

                 - [[Home]]
                 - [[Getting Started]]
                 """

          refute file =~ """
                 ## Infrastructure

                 - [[Application Status]]
                 """
        end)
      end)
    end
  end
end
