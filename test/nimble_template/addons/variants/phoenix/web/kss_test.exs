defmodule NimbleTemplate.Addons.Phoenix.Web.KssTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "adds kss and a custom script into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Kss.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                     "kss": "^3.0.1",
                 """

          assert file =~ """
                     "styleguide.generate": "kss --config .kss-config.json",
                 """
        end)
      end)
    end

    test "updates lib/nimble_template_web/endpoint.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file("lib/nimble_template_web/endpoint.ex", fn file ->
          assert file =~ """
                   only: ~w(css fonts images styleguide js favicon.ico robots.txt)
                 """
        end)
      end)
    end
  end
end
