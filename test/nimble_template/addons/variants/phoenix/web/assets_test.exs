defmodule NimbleTemplate.Addons.Phoenix.Web.AssetsTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "enables gzip for static", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Assets.apply(project)

        assert_file("lib/nimble_template_web/endpoint.ex", fn file ->
          assert file =~ "gzip: true,"
        end)
      end)
    end
  end
end
