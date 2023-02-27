defmodule NimbleTemplate.Addons.AsdfToolVersionTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.Addons.AsdfToolVersion

  describe "#apply!/2 with web_project" do
    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        AsdfToolVersion.apply!(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 25.2.3
                 elixir 1.14.3-otp-25
                 nodejs 18.14.2
                 """
        end)
      end)
    end
  end

  describe "#apply!/2 with api_project" do
    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project!(test_project_path, fn ->
        AsdfToolVersion.apply!(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 25.2.3
                 elixir 1.14.3-otp-25
                 """

          refute file =~ "nodejs 18.14.2"
        end)
      end)
    end
  end

  describe "#apply!/2 with mix_project" do
    @describetag mix_project?: true

    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        AsdfToolVersion.apply!(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 25.2.3
                 elixir 1.14.3-otp-25
                 """

          refute file =~ "nodejs 18.14.2"
        end)
      end)
    end
  end
end
