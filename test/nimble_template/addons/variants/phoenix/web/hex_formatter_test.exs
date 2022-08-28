defmodule NimbleTemplate.Addons.Phoenix.Web.HeexFormatterTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "adds the HTMLFormatter into the .formatter.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.HeexFormatter.apply(project)

        assert_file(".formatter.exs", fn file ->
          assert file =~ """
                 plugins: [Phoenix.LiveView.HTMLFormatter],
                 """

          assert file =~ """
                 inputs: ["*.{heex,ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{heex,ex,exs}"],
                 """
        end)
      end)
    end
  end
end
