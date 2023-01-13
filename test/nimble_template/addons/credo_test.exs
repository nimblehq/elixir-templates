defmodule NimbleTemplate.Addons.CredoTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    @describetag mock_latest_package_versions: [{:credo, "1.4"}, {:compass_credo_plugin, "1.0.0"}]
    @describetag required_addons: [:TestEnv]

    test "copies the .credo.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.Credo.apply!(project)

        assert_file(".credo.exs", fn file ->
          assert file =~ """
                 {Credo.Check.Consistency.MultiAliasImportRequireUse,
                           files: %{
                             excluded: [
                               "lib/nimble_template.ex",
                               "lib/nimble_template_web.ex",
                               "test/support/conn_case.ex",
                               "test/support/data_case.ex",
                               "test/support/feature_case.ex"
                             ]
                           }},
                 """
        end)
      end)
    end

    test "injects credo to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.Credo.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:credo, "~> 1.4", [only: [:dev, :test], runtime: false]},
                       {:compass_credo_plugin, "~> 1.0.0", [only: [:dev, :test], runtime: false]},
                 """
        end)
      end)
    end

    test "adds credo codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.Credo.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [
                         "credo --strict",
                 """
        end)
      end)
    end
  end

  describe "#apply!/2 with mix_project" do
    @describetag mix_project?: true
    @describetag mock_latest_package_versions: [{:credo, "1.4"}, {:compass_credo_plugin, "1.0.0"}]
    @describetag required_addons: [:TestEnv]

    test "copies the .credo.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.Credo.apply!(project)

        assert_file(".credo.exs", fn file ->
          assert file =~ """
                 {Credo.Check.Consistency.MultiAliasImportRequireUse, []},
                 """
        end)
      end)
    end

    test "injects credo to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.Credo.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:credo, "~> 1.4", [only: [:dev, :test], runtime: false]},
                 """
        end)
      end)
    end

    test "adds credo codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project!(test_project_path, fn ->
        Addons.Credo.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [
                         "credo --strict",
                 """
        end)
      end)
    end
  end
end
