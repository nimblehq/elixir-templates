defmodule Nimble.Phx.Gen.Template.Addons.Web.AssetsTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    test "adds assets.compile alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.Web.Assets.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       \"assets.compile\": &compile_assets/1,
                 """
        end)
      end)
    end

    test "defines compile_assets method", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Web.Assets.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp compile_assets(_) do
                     Mix.shell().cmd("npm run --prefix assets build:dev", quiet: true)
                   end
                 """
        end)
      end)
    end
  end
end