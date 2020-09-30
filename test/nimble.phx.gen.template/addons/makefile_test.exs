defmodule Nimble.Phx.Gen.Template.Addons.MakefileTest do
  use Nimble.Phx.Gen.Template.AddonCase, async: true

  describe "#apply/2" do
    test "copies the Makefile into the project", %{project: project, test_app_path: test_app_path} do
      in_test_app(test_app_path, fn ->
        Addons.Makefile.apply(project, {})

        assert_file("Makefile", fn file ->
          assert file =~ ".PHONY: docker_setup"
          assert file =~ "docker_setup:"
          assert file =~ "docker-compose -f docker-compose.dev.yml up -d"
        end)
      end)
    end
  end
end
