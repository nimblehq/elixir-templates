defmodule NimbleTemplate.Addons.ElixirVersionTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ElixirVersion.apply(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 24.0.4
                 elixir 1.12.2-otp-24
                 """
        end)
      end)
    end
  end
end
