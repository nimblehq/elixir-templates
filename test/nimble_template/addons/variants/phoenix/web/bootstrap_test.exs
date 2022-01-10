defmodule NimbleTemplate.Addons.Phoenix.Web.BootstrapTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [:TestEnv, :"Phoenix.Web.StyleLint"]

    test "copies Bootstrap file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.CoreJS.apply(project)
        WebAddons.NimbleCSS.apply(project)
        WebAddons.Bootstrap.apply(project)

        assert_file("assets/css/vendor/_bootstrap.scss")
      end)
    end

    test "adds Bootstrap into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.CoreJS.apply(project)
        WebAddons.NimbleCSS.apply(project)
        WebAddons.Bootstrap.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
            "bootstrap": "^5.0.0",
            """
        end)
      end)
    end

    test "imports Bootstrap into app.js", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        WebAddons.CoreJS.apply(project)
        WebAddons.NimbleCSS.apply(project)
        WebAddons.Bootstrap.apply(project)

        assert_file("assets/js/app.js", fn file ->
          assert file =~ """
            import "bootstrap/dist/js/bootstrap";
            """
        end)
      end)
    end

    test "imports Bootstrap into app.scss", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        WebAddons.CoreJS.apply(project)
        WebAddons.NimbleCSS.apply(project)
        WebAddons.Bootstrap.apply(project)

        assert_file("assets/css/app.scss", fn file ->
          assert file =~ """
            @import 'vendor/boostrap';
            """
        end)
      end)
    end
  end
end
