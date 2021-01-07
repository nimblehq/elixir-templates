defmodule Nimble.Elixir.Template.Addons.ElixirVersionTest do
  use Nimble.Elixir.Template.AddonCase

  describe "#apply/2" do
    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ElixirVersion.apply(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 23.2.1
                 elixir 1.11.3-otp-23
                 """
        end)
      end)
    end

    test "changes the minimum Elixir version", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ElixirVersion.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ "elixir: \"~> 1.11.3\","
        end)
      end)
    end
  end
end
