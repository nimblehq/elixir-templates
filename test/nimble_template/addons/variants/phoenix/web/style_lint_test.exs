defmodule NimbleTemplate.Addons.Phoenix.Web.StyleLintTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    @describetag required_addons: [:TestEnv, :"Phoenix.Web.NodePackage"]

    test "adds stylelint,
          stylelint-config-property-sort-order-smacss
          and stylelint-config-sass-guidelines into package.json",
         %{
           project: project,
           test_project_path: test_project_path
         } do
      in_test_project!(test_project_path, fn ->
        WebAddons.StyleLint.apply!(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "devDependencies": {
                     "stylelint": "14.7.1",
                     "@nimblehq/stylelint-config-nimble": "1.0.0",
                 """
        end)
      end)
    end

    test "adds stylelint and stylelint.fix into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.StyleLint.apply!(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "scripts": {
                     "stylelint": "stylelint --color ./css",
                     "stylelint.fix": "stylelint --color --fix ./css",
                 """
        end)
      end)
    end

    test "adds stylelint into the codebase alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.StyleLint.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       codebase: [
                         "cmd npm run stylelint --prefix assets",
                 """
        end)
      end)
    end

    test "adds stylelint.fix into the codebase.fix alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.StyleLint.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "codebase.fix": [
                         "cmd npm run stylelint.fix --prefix assets",
                 """
        end)
      end)
    end

    test "copies the .stylelintrc.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.StyleLint.apply!(project)

        assert_file("assets/.stylelintrc.json")
      end)
    end
  end
end
