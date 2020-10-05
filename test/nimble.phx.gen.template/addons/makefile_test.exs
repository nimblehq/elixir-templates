defmodule Nimble.Phx.Gen.Template.Addons.MakefileTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    test "copies the Makefile", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.Makefile.apply(project, {})

        assert_file("Makefile", fn file ->
          assert file =~ """
                 .PHONY: docker_setup

                 docker_setup:
                 \tdocker-compose -f docker-compose.dev.yml up -d
                 """
        end)
      end)
    end
  end
end
