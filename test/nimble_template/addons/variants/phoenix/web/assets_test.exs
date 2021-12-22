defmodule NimbleTemplate.Addons.Phoenix.Web.AssetsTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [:TestEnv, :Credo]

    test "adds assets.compile alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Assets.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       \"assets.compile\": &compile_assets/1,
                 """
        end)
      end)
    end

    test "adds eslint and stylelint into the codebase alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Assets.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       codebase: [
                         \"deps.unlock --check-unused\",
                         \"format --check-formatted\",
                         \"credo --strict\",
                         \"cmd npm run eslint --prefix assets\",
                         \"cmd npm run stylelint --prefix assets\"
                       ],
                 """
        end)
      end)
    end

    test "adds eslint.fix and stylelint.fix into the codebase.fix alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Assets.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "codebase.fix": [
                         \"deps.clean --unlock --unused\",
                         \"format\",
                         \"cmd npm run eslint.fix --prefix assets\",
                         \"cmd npm run stylelint.fix --prefix assets\"
                       ],
                 """
        end)
      end)
    end

    test "defines compile_assets method", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Assets.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp compile_assets(_) do
                     Mix.shell().cmd("npm run --prefix assets build:dev", quiet: true)
                   end
                 """
        end)
      end)
    end

    test "adds scripts into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Assets.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                     "build:dev": "webpack --mode development",
                     "stylelint": "stylelint --color ./css",
                     "stylelint.fix": "stylelint --color --fix ./css",
                     "eslint": "eslint --color ./",
                     "eslint.fix": "eslint --color --fix ./"
                 """
        end)
      end)
    end
  end
end
