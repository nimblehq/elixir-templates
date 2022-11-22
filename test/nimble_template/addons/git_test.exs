defmodule NimbleTemplate.Addons.GitTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "adjusts the .gitignore file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.Git.apply!(project)

        assert_file(".gitignore", fn file ->
          assert file =~ """
                 # Mac OS
                 .DS_Store

                 # IDE
                 .idea
                 .vscode

                 # Iex
                 .iex.exs

                 # Ignore ElixirLS files
                 .elixir_ls
                 """
        end)
      end)
    end
  end

  describe "#apply!/2 with mix_project" do
    @describetag mix_project?: true

    test "adjusts the .gitignore file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        Addons.Git.apply!(project)

        assert_file(".gitignore", fn file ->
          assert file =~ """
                 # Mac OS
                 .DS_Store

                 # IDE
                 .idea
                 .vscode

                 # Iex
                 .iex.exs

                 # Ignore ElixirLS files
                 .elixir_ls
                 """
        end)
      end)
    end
  end
end
