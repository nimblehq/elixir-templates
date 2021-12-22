defmodule NimbleTemplate.DependencyTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.{Addons, DependencyHelper}

  describe "order_dependencies!/0" do
    @describetag mock_latest_package_versions: [{:exvcr, "0.12.2"}, {:mimic, "1.3.1"}]

    test "orders dependencies in alphabetical order", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExVCR.apply(project)
        Addons.Mimic.apply(project)

        # Unordered mix dependencies
        assert_file("mix.exs", fn file ->
          assert file =~ ~r/(:mimic).*(:exvcr)/s
        end)

        DependencyHelper.order_dependencies!()

        # Ordered mix dependencies
        assert_file("mix.exs", fn file ->
          assert file =~ ~r/(:exvcr).*(:mimic)/s
        end)
      end)
    end
  end
end
