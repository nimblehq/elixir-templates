defmodule NimbleTemplate.Addons.Phoenix.Web.GithubWikiTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies the .github/workflows/publish_wiki.yml", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.GithubWiki.apply(project)

        assert_file(".github/workflows/publish_wiki.yml")
      end)
    end
  end
end
