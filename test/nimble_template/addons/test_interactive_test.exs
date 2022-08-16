defmodule NimbleTemplate.Addons.TestInteractiveTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:mix_test_interactive, "1.2"}]

    test "injects mix_test_interactive to mix dependencies list", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.TestInteractive.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:mix_test_interactive, "~> 1.2", [only: :dev, runtime: false]},
                 """
        end)
      end)
    end

    test "injects mix_test_interactive config to the dev config", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.TestInteractive.apply(project)

        assert_file("config/dev.exs", fn file ->
          assert file =~ """
                 config :mix_test_interactive,
                   clear: true
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project" do
    @describetag mix_project?: true
    @describetag mock_latest_package_versions: [{:mix_test_interactive, "1.2"}]

    test "injects mix_test_interactive to mix dependencies list", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.TestInteractive.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:mix_test_interactive, "~> 1.2", [only: :dev, runtime: false]},
                 """
        end)
      end)
    end
  end
end
