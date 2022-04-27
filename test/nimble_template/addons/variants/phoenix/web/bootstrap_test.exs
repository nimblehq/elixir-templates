defmodule NimbleTemplate.Addons.Phoenix.Web.BootstrapTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2 given no Nimble CSS and Nimble JS structure" do
    @describetag required_addons: [
                   :TestEnv,
                   :"Phoenix.Web.NodePackage",
                   :"Phoenix.Web.EsBuild",
                   :"Phoenix.Web.DartSass"
                 ]

    test "copies Bootstrap vendor file", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: false,
          with_nimble_js_addon: false
        })

        assert_file("assets/css/vendor/_bootstrap.scss")
      end)
    end

    test "adds Bootstrap into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: false,
          with_nimble_js_addon: false
        })

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "dependencies": {
                     "@popperjs/core": "2.11.5",
                     "bootstrap": "5.1.3",
                 """
        end)
      end)
    end

    test "imports Bootstrap into app.js given", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_js_addon: false,
          with_nimble_css_addon: false
        })

        assert_file("assets/js/app.js", fn file ->
          assert file =~ """
                 import "bootstrap/dist/js/bootstrap";
                 """
        end)
      end)
    end

    test "imports Vendor into app.scss", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: false,
          with_nimble_js_addon: false
        })

        assert_file("assets/css/app.scss", fn file ->
          assert file =~ """
                 @import "./phoenix.css";

                 @import './vendor/';
                 """
        end)
      end)
    end

    test "imports bootstrap vendor index file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: false,
          with_nimble_js_addon: false
        })

        assert_file("assets/css/vendor/_index.scss", fn file ->
          assert file =~ "@import './bootstrap';"
        end)
      end)
    end

    test "creates the assets/css/_variables.scss", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: false,
          with_nimble_js_addon: false
        })

        assert_file("assets/css/_variables.scss", fn file ->
          assert file =~ """
                 ////////////////////////////////
                 // Shared variables           //
                 ////////////////////////////////


                 ////////////////////////////////
                 // Custom Bootstrap variables //
                 ////////////////////////////////
                 """
        end)
      end)
    end
  end

  describe "#apply/2 given Nimble CSS and Nimble JS structure" do
    @describetag required_addons: [
                   :TestEnv,
                   :"Phoenix.Web.NodePackage",
                   :"Phoenix.Web.StyleLint",
                   :"Phoenix.Web.EsLint",
                   :"Phoenix.Web.EsBuild",
                   :"Phoenix.Web.DartSass",
                   :"Phoenix.Web.NimbleCSS",
                   :"Phoenix.Web.NimbleJS"
                 ]

    test "copies Bootstrap vendor file", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: true,
          with_nimble_js_addon: true
        })

        assert_file("assets/css/vendor/_bootstrap.scss")
      end)
    end

    test "adds Bootstrap into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: true,
          with_nimble_js_addon: true
        })

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "dependencies": {
                     "@popperjs/core": "2.11.5",
                     "bootstrap": "5.1.3",
                 """
        end)
      end)
    end

    test "imports Bootstrap into app.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: true,
          with_nimble_js_addon: true
        })

        assert_file("assets/js/app.js", fn file ->
          assert file =~ """
                 import "bootstrap/dist/js/bootstrap";
                 """
        end)
      end)
    end

    test "does not import Vendor into app.scss", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: true,
          with_nimble_js_addon: true
        })

        assert_file("assets/css/app.scss", fn file ->
          assert file =~ """
                 @import './functions';

                 @import './vendor';
                 """
        end)
      end)
    end

    test "imports bootstrap vendor index file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: true,
          with_nimble_js_addon: true
        })

        assert_file("assets/css/vendor/_index.scss", fn file ->
          assert file =~ "@import './bootstrap';"
        end)
      end)
    end

    test "updates the assets/css/_variables.scss", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.Bootstrap.apply(project, %{
          with_nimble_css_addon: true,
          with_nimble_js_addon: true
        })

        assert_file("assets/css/_variables.scss", fn file ->
          assert file =~ """
                 ////////////////////////////////
                 // Shared variables           //
                 ////////////////////////////////


                 ////////////////////////////////
                 // Custom Bootstrap variables //
                 ////////////////////////////////
                 """
        end)
      end)
    end
  end
end
