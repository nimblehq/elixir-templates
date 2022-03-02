defmodule NimbleTemplate.Addons.Phoenix.Web.PrettierTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [:TestEnv, :"Phoenix.Web.NodePackage"]

    test "adds prettier and prettier-plugin-eex into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Prettier.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "devDependencies": {
                     "prettier": "2.5.1",
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
        WebAddons.Prettier.apply(project)

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

    test "adds prettier into the codebase alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Prettier.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       codebase: [
                         "prettier",
                 """
        end)
      end)
    end

    test "adds prettier.fix into the codebase.fix alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Prettier.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "codebase.fix": [
                         "prettier.fix",
                 """
        end)
      end)
    end

    test "copies the .prettierignore and .prettierrc.yaml", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Prettier.apply(project)

        assert_file(".prettierignore")
        assert_file(".prettierrc.yaml")
      end)
    end
  end
end
