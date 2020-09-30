defmodule Nimble.Phx.Gen.Template.Addons.MakefileTest do
  use Nimble.Phx.Gen.Template.AddonCase, async: true

  describe "#apply/2" do
    test "copies the Makefile into the project", %{project: project, test_app_path: test_app_path} do
      in_test_app(test_app_path, fn ->
        Addons.Makefile.apply(project, {})

        assert File.regular?("Makefile") === true
      end)
    end
  end
end
