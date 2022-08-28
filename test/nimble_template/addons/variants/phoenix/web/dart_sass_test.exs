defmodule NimbleTemplate.Addons.Phoenix.Web.DartSassTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [
                   :"Phoenix.Web.NodePackage",
                   :"Phoenix.Web.EsBuild",
                   :"Phoenix.Web.PostCSS"
                 ]
    @describetag mock_latest_package_versions: [{:dart_sass, "0.26.2"}]

    test "remove the import `css/app.css` in assets/js/app.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.DartSass.apply(project)

        assert_file("assets/js/app.js", fn file ->
          refute file =~ """
                 // We import the CSS which is extracted to its own file by esbuild.
                 // Remove this line if you add a your own CSS build pipeline (e.g postcss).
                 import "../css/app.css"

                 """
        end)
      end)
    end

    test "adds sass step into the mix assets.deploy alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.DartSass.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "assets.deploy": [
                         "esbuild app --minify",
                         "sass app --no-source-map --style=compressed",
                         "cmd npm run postcss --prefix assets",
                         "phx.digest"
                       ]
                 """
        end)
      end)
    end

    test "adds dart_sass configuration into the config.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.DartSass.apply(project)

        assert_file("config/config.exs", fn file ->
          assert file =~ """
                 # Configure dart_sass (the version is required)
                 config :dart_sass,
                   version: "1.49.11",
                   app: [
                     args: ~w(
                       --load-path=./node_modules
                       css/app.scss
                       ../priv/static/assets/app.css
                       ),
                     cd: Path.expand("../assets", __DIR__)
                   ]
                 """
        end)
      end)
    end

    test "adds sass into the development watcher", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.DartSass.apply(project)

        assert_file("config/dev.exs", fn file ->
          assert file =~ """
                   watchers: [
                     app_sass: {
                       DartSass,
                       :install_and_run,
                       [:app, ~w(--embed-source-map --source-map-urls=absolute --watch)]
                     },
                 """
        end)
      end)
    end

    test "injects dart_sass to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.DartSass.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:dart_sass, "~> 0.26.2", [runtime: Mix.env() == :dev]},
                 """
        end)
      end)
    end

    test "rename app.css into app.scss", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.DartSass.apply(project)

        assert_file("assets/css/app.scss")
        refute_file("assets/css/app.css")
      end)
    end
  end
end
