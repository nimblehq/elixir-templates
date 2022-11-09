defmodule NimbleTemplate.Addons.AsdfToolVersionTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.Addons.AsdfToolVersion
  alias NimbleTemplate.Projects.Project

  describe "#apply/2 with web_project" do
    test "copies the .tool-versions", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.AsdfToolVersion.apply(project)

        assert_file(".tool-versions", fn file ->
          assert file =~ """
                 erlang 25.1.2
                 elixir 1.14.1-otp-25
                 nodejs 18.12.1
                 """
        end)
      end)
    end

    test "appends NimbleTemplate.Addons.AsdfToolVersion to project installed_addons list", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        %Project{installed_addons: installed_addons} = Addons.AsdfToolVersion.apply(project)

        assert AsdfToolVersion in installed_addons == true
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
                 erlang 25.1.2
                 elixir 1.14.1-otp-25
                 """

          refute file =~ "nodejs 18.12.1"
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
                 erlang 25.1.2
                 elixir 1.14.1-otp-25
                 """

          refute file =~ "nodejs 18.12.1"
        end)
      end)
    end
  end
end
