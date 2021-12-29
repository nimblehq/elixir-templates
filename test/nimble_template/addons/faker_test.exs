defmodule NimbleTemplate.Addons.FakerTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:faker, "0.17.0"}]

    test "injects faker to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Faker.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:faker, "~> 0.17.0", [only: [:dev, :test], runtime: false]},
                 """
        end)
      end)
    end
  end
end
