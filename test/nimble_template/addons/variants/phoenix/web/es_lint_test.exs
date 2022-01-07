defmodule NimbleTemplate.Addons.Phoenix.Web.EsLintTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [:TestEnv]

    test "adds eslint, eslint-config-prettier and eslint-plugin-prettier into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsLint.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                     "eslint": "^8.5.0",
                     "eslint-config-prettier": "^8.3.0",
                     "eslint-plugin-prettier": "^4.0.0",
                 """
        end)
      end)
    end

    test "adds eslint and eslint.fix into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsLint.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                     "eslint": "eslint --color ./",
                     "eslint.fix": "eslint --color --fix ./",
                 """
        end)
      end)
    end

    test "adds eslint into the codebase alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsLint.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       codebase: [
                         "cmd npm run eslint --prefix assets",
                 """
        end)
      end)
    end

    test "adds eslint.fix into the codebase.fix alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsLint.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "codebase.fix": [
                         "cmd npm run eslint.fix --prefix assets",
                 """
        end)
      end)
    end

    test "copies the .eslintrc.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsLint.apply(project)

        assert_file("assets/.eslintrc.json")
      end)
    end
  end

  describe "#apply/2 to a Live project" do
    @describetag live_project?: true
    @describetag required_addons: [:TestEnv]

    test "updates the assets/js/app.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.EsLint.apply(project)

        assert_file("assets/js/app.js", fn file ->
          assert file =~
                   "window.addEventListener(\"phx:page-loading-start\", _info => topbar.show())"

          assert file =~
                   "window.addEventListener(\"phx:page-loading-stop\", _info => topbar.hide())"
        end)
      end)
    end
  end
end
