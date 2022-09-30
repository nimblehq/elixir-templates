defmodule NimbleTemplate.Addons.IexTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "add the .iex.exs file with the Repo alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Iex.apply(project)

        assert_file(".iex.exs", fn file ->
          assert file =~ """
                 alias NimbleTemplate.Repo
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project" do
    @describetag mix_project?: true

    test "does not include the Repo alias in .iex.exs file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Iex.apply(project)

        assert_file(".iex.exs", fn file ->
          refute file =~ """
                 alias NimbleTemplate.Repo
                 """
        end)
      end)
    end
  end
end
