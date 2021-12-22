defmodule NimbleTemplate.Addons.Phoenix.Web.PrettierTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:credo, "0.26.2"}]
    @describetag required_addons: [:TestEnv, :Credo]

    test "adds prettier and prettier-plugin-eex into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Prettier.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                     "prettier": "2.2.1",
                     "prettier-plugin-eex": "^0.5.0"
                 """
        end)
      end)
    end

    test "injects prettier to mix aliases", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Prettier.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       prettier: "cmd ./assets/node_modules/.bin/prettier --check . --color",
                       "prettier.fix": "cmd ./assets/node_modules/.bin/prettier --write . --color",
                 """
        end)
      end)
    end

    test "adds prettier codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Prettier.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       codebase: [
                         \"deps.unlock --check-unused\",
                         \"format --check-formatted\",
                         \"credo --strict\",
                         \"prettier\"
                       ],
                 """
        end)
      end)
    end

    test "copies the .prettierignore and .prettierrc", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Prettier.apply(project)

        assert_file(".prettierignore")
        assert_file(".prettierrc")
      end)
    end
  end
end
