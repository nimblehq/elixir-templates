defmodule NimbleTemplate.Addons.GettextTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "injects gettext.extract-and-merge command to mix aliases and codebase.fix", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Gettext.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                  "gettext.extract-and-merge": ["gettext.extract --merge --no-fuzzy"],
                 """
        end)
      end)
    end
  end
end
