defmodule NimbleTemplate.VersionTest do
  use NimbleTemplate.TemplateCase, async: false

  alias NimbleTemplate.Version

  describe "bump!/1" do
    test "updates the version in mix.exs and README.md files given a valid version number", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        current_version = Mix.Project.config()[:version]

        patch_number =
          current_version
          |> String.split(".")
          |> List.last()
          |> String.to_integer()

        # Increase the patch version to 1
        new_version =
          current_version
          |> String.split(".")
          |> List.replace_at(2, patch_number + 1)
          |> Enum.join(".")

        assert Version.bump!(new_version) == :ok

        assert_file("mix.exs", fn file ->
          assert file =~ "version: \"#{new_version}\""
          refute file =~ "version: \"#{current_version}\""
        end)

        assert_file("README.md", fn file ->
          assert file =~ "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"

          refute file =~
                   "{:nimble_template, \"~> #{current_version}\", only: :dev, runtime: false},"
        end)
      end)
    end

    test "raises Mix.Error exception given an invalid version number", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        current_version = Mix.Project.config()[:version]

        major_number =
          current_version
          |> String.split(".")
          |> List.first()
          |> String.to_integer()

        # Decrease the major version to 1
        new_version =
          current_version
          |> String.split(".")
          |> List.replace_at(0, major_number - 1)
          |> Enum.join(".")

        assert_raise Mix.Error, "The new version must be greater than #{current_version}", fn ->
          Version.bump!(new_version)
        end

        assert_file("mix.exs", fn file ->
          assert file =~ "version: \"#{current_version}\""
          refute file =~ "version: \"#{new_version}\""
        end)

        assert_file("README.md", fn file ->
          assert file =~
                   "{:nimble_template, \"~> #{current_version}\", only: :dev, runtime: false},"

          refute file =~ "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"
        end)
      end)
    end
  end

  describe "upgrade_stack!/1" do
    test "upgrade elixir version given the new elixir_version", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        assert Version.upgrade_stack!(elixir: "a.b.c") == :ok

        assert_file("lib/nimble_template/projects/project.ex", fn file ->
          assert file =~ "@elixir_version \"a.b.c\""
        end)

        assert_file(".tool-versions", fn file ->
          assert file =~ "elixir a.b.c-otp-"
        end)

        assert_file("test/nimble_template/addons/asdf_tool_version_test.exs", fn file ->
          assert file =~ "elixir a.b.c-otp-"
        end)

        assert_file("test/nimble_template/addons/github_test.exs", fn file ->
          assert file =~ "Elixir a.b.c"
        end)

        assert_file("test/nimble_template/addons/readme_test.exs", fn file ->
          assert file =~ "Elixir a.b.c"
        end)

        assert_file("test/nimble_template/addons/variants/docker_test.exs", fn file ->
          assert file =~ "ELIXIR_IMAGE_VERSION=a.b.c"
        end)
      end)
    end

    test "upgrade erlang version given the new erlang_version", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        assert Version.upgrade_stack!(erlang: "x.y.z") == :ok

        assert_file("lib/nimble_template/projects/project.ex", fn file ->
          assert file =~ "@erlang_version \"x.y.z\""
        end)

        assert_file(".tool-versions", fn file ->
          assert file =~ "erlang x.y.z"
          assert file =~ "-otp-x"
        end)

        assert_file("test/nimble_template/addons/asdf_tool_version_test.exs", fn file ->
          assert file =~ "erlang x.y.z"
          assert file =~ "-otp-x"
        end)

        assert_file("test/nimble_template/addons/github_test.exs", fn file ->
          assert file =~ "Erlang x.y.z"
        end)

        assert_file("test/nimble_template/addons/readme_test.exs", fn file ->
          assert file =~ "Erlang x.y.z"
        end)

        assert_file("test/nimble_template/addons/variants/docker_test.exs", fn file ->
          assert file =~ "ERLANG_IMAGE_VERSION=x.y.z"
        end)
      end)
    end

    test "upgrade node version given the new node_version", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        assert Version.upgrade_stack!(node: "a.s.d") == :ok

        assert_file("lib/nimble_template/projects/project.ex", fn file ->
          assert file =~ "@node_asdf_version \"a.s.d\""
        end)

        assert_file(".tool-versions", fn file ->
          assert file =~ "nodejs a.s.d"
        end)

        assert_file("test/nimble_template/addons/asdf_tool_version_test.exs", fn file ->
          assert file =~ "nodejs a.s.d"
        end)

        assert_file("test/nimble_template/addons/github_test.exs", fn file ->
          assert file =~ "Node a.s.d"
        end)

        assert_file("test/nimble_template/addons/readme_test.exs", fn file ->
          assert file =~ "Node a.s.d"
        end)
      end)
    end

    test "upgrade alpine version given the new alpine_version", %{
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        assert Version.upgrade_stack!(alpine: "z.x.c") == :ok

        assert_file("lib/nimble_template/projects/project.ex", fn file ->
          assert file =~ "@alpine_version \"z.x.c\""
        end)

        assert_file("test/nimble_template/addons/variants/docker_test.exs", fn file ->
          assert file =~ "RELEASE_IMAGE_VERSION=z.x.c"
        end)
      end)
    end
  end
end
