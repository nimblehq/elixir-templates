defmodule NimbleTemplate.Addons.AsdfToolVersionTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2 with web_project" do
    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.AsdfToolVersion.apply(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 24.2.2
                 elixir 1.13.3-otp-24
                 nodejs 16.15.0
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with api_project" do
    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.AsdfToolVersion.apply(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 24.2.2
                 elixir 1.13.3-otp-24
                 """

          refute file =~ "nodejs 16.15.0"
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project" do
    @describetag mix_project?: true

    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.AsdfToolVersion.apply(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 24.2.2
                 elixir 1.13.3-otp-24
                 """

          refute file =~ "nodejs 16.15.0"
        end)
      end)
    end
  end
end
