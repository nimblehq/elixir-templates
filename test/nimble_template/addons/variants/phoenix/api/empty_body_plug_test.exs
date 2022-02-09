defmodule NimbleTemplate.Addons.Phoenix.Api.EmptyBodyParamsPlugTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies the empty body plug file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        ApiAddons.EmptyBodyParamsPlug.apply(project)

        assert_file("lib/nimble_template_web/plugs/check_empty_body_params_plug.ex")
      end)
    end

    test "copies the empty body plug test file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        ApiAddons.EmptyBodyParamsPlug.apply(project)

        assert_file("test/nimble_template_web/plugs/check_empty_body_params_plug_test.exs")
      end)
    end

    test "adds CheckEmptyBodyParamsPlug into the api pipeline", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        ApiAddons.EmptyBodyParamsPlug.apply(project)

        assert_file("lib/nimble_template_web/router.ex", fn file ->
          assert file =~ """
                   pipeline :api do
                     plug :accepts, ["json"]
                     plug NimbleTemplateWeb.CheckEmptyBodyParamsPlug
                   end
                 """
        end)
      end)
    end
  end
end
