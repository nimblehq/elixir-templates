defmodule Nimble.Phx.Gen.Template.Addons.DialyxirTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    test "injects dialyxir to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Dialyxir.apply(project, {})

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:dialyxir, \"~> 1.0\", [only: [:dev], runtime: false]},
                 """
        end)
      end)
    end
  end
end
