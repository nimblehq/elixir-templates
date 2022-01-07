defmodule NimbleTemplate.Addons.Phoenix.Web.SvgSpriteTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "adds svg-sprite into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                     "svg-sprite": "^1.5.3",
                 """
        end)
      end)
    end

    test "adds svg-sprite.generate-icon into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                 "svg-sprite.generate-icon": "svg-sprite --shape-id-generator \\"icon-%s\\" --symbol --symbol-dest static/images --symbol-sprite icon-sprite.svg static/images/icons/*.svg",
                 """
        end)
      end)
    end

    test "adds `import NimbleTemplateWeb.IconHelper` into lib/nimble_template_web.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        assert_file("lib/nimble_template_web.ex", fn file ->
          assert file =~ """
                 import NimbleTemplateWeb.IconHelper
                 """
        end)
      end)
    end

    test "copies the icon_helper.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        assert_file("lib/nimble_template_web/helpers/icon_helper.ex")
      end)
    end

    test "copies the icon_helper_test.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        assert_file("test/nimble_template_web/helpers/icon_helper_test.exs")
      end)
    end

    test "does NOT copy `.github/wiki/Icon-Sprite.md`", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        refute_file(".github/wiki/Icon-Sprite.md")
      end)
    end

    test "does NOT copy `.github/wiki/_Sidebar.md`", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        refute_file(".github/wiki/_Sidebar.md")
      end)
    end
  end

  describe "#apply/2 with Github Wiki addon" do
    @describetag required_addons: [{:Github, %{github_wiki: true}}]

    test "copies `.github/wiki/Icon-Sprite.md`", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        assert_file(".github/wiki/Icon-Sprite.md")
      end)
    end

    test "adds `Icon Sprite` into `.github/wiki/_Sidebar.md`", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.SvgSprite.apply(project)

        assert_file(".github/wiki/_Sidebar.md", fn file ->
          assert file =~ """
                 ## Operations

                 - [[Icon Sprite]]
                 """
        end)
      end)
    end
  end
end
