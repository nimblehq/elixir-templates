defmodule Nimble.Phx.Gen.Template.Addons.GithubTest do
  use Nimble.Phx.Gen.Template.AddonCase

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
  end

  describe "#apply/2 with api_project and github_action option" do
    test "does NOT include the npm setting", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action: true})

        assert_file(".github/workflows/test.yml", fn file ->
          refute file =~ "assets/node_modules"
          refute file =~ "npm --prefix assets install"
          refute file =~ "npm run --prefix assets build:dev"
          refute file =~ "wallaby_screenshots"
        end)
      end)
    end
  end

  describe "#apply/2 with web_project and github_action option" do
    test "includes the npm setting", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action: true})

        assert_file(".github/workflows/test.yml", fn file ->
          assert file =~ "assets/node_modules"
          assert file =~ "npm --prefix assets install"
          assert file =~ "npm run --prefix assets build:dev"
          assert file =~ "wallaby_screenshots"
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project and github_action option" do
    @describetag mix_project?: true

    test "does NOT include database setting", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Github.apply(project, %{github_action: true})

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
        Addons.Github.apply(project, %{github_action: true})

        assert_file(".github/workflows/test.yml", fn file ->
          refute file =~ "assets/node_modules"
          refute file =~ "npm --prefix assets install"
          refute file =~ "npm run --prefix assets build:dev"
          refute file =~ "wallaby_screenshots"
        end)
      end)
    end
  end
end
