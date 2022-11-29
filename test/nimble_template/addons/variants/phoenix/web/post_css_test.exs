defmodule NimbleTemplate.Addons.Phoenix.Web.PostCSSTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    @describetag required_addons: [
                   :"Phoenix.Web.NodePackage",
                   :"Phoenix.Web.EsBuild"
                 ]
    test "adds postcss step into the mix assets.deploy alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.PostCSS.apply!(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "assets.deploy": [
                         "esbuild app --minify",
                         "cmd npm run postcss --prefix assets",
                         "phx.digest"
                       ]
                 """
        end)
      end)
    end

    test "adds postcss into the development watcher", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.PostCSS.apply!(project)

        assert_file("config/dev.exs", fn file ->
          assert file =~ """
                   watchers: [
                     npm: [
                       "run",
                       "postcss.watch",
                       cd: Path.expand("../assets", __DIR__)
                     ],
                 """
        end)
      end)
    end

    test "adds postcss library and dependencies into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.PostCSS.apply!(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "devDependencies": {
                     "postcss": "8.4.19",
                     "postcss-scss": "4.0.6",
                     "postcss-cli": "9.1.0",
                     "postcss-load-config": "3.1.4",
                     "autoprefixer": "10.4.5",
                 """
        end)
      end)
    end

    test "adds postcss and postcss.watch into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.PostCSS.apply!(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "scripts": {
                     "postcss": "postcss ../priv/static/assets/*.css --dir ../priv/static/assets/ --config ./",
                     "postcss.watch": "postcss ../priv/static/assets/*.css --dir ../priv/static/assets/ --config ./ --watch",
                 """
        end)
      end)
    end

    test "copies the postcss.config.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        WebAddons.PostCSS.apply!(project)

        assert_file("assets/postcss.config.js")
      end)
    end
  end
end
