defmodule NimbleTemplate.VersionTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.Version

  setup do
    on_exit(fn ->
      Mix.shell().cmd("git checkout .")
    end)
  end

  describe "bump/1" do
    test "updates the version in mix.exs and README.md files given a valid version number" do
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

      assert Version.bump(new_version) == :ok

      assert_file("mix.exs", fn file ->
        assert file =~ "version: \"#{new_version}\""
        refute file =~ "version: \"#{current_version}\""
      end)

      assert_file("README.md", fn file ->
        assert file =~ "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"
        refute file =~ "{:nimble_template, \"~> #{current_version}\", only: :dev, runtime: false},"
      end)
    end

    test "raises Mix.Error exception given an invalid version number" do
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
        Version.bump(new_version)
      end

      assert_file("mix.exs", fn file ->
        assert file =~ "version: \"#{current_version}\""
        refute file =~ "version: \"#{new_version}\""
      end)

      assert_file("README.md", fn file ->
        assert file =~ "{:nimble_template, \"~> #{current_version}\", only: :dev, runtime: false},"
        refute file =~ "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"
      end)
    end
  end

  describe "upgrade_elixir_erlang_node_and_alpine/1" do
    test "upgrade elixir version given the new elixir_version" do
      assert Version.upgrade_elixir_erlang_node_and_alpine(%{elixir_version: "130.13.4"}) == :ok

      assert_file("lib/nimble_template/projects/project.ex", fn file ->
        assert file =~ "@elixir_version \"130.13.4\""
      end)

      assert_file("test/nimble_template/addons/asdf_tool_version_test.exs", fn file ->
        assert file =~ "elixir 130.13.4-otp-"
      end)

      assert_file("test/nimble_template/addons/github_test.exs", fn file ->
        assert file =~ "Elixir 130.13.4"
      end)

      assert_file("test/nimble_template/addons/readme_test.exs", fn file ->
        assert file =~ "Elixir 130.13.4"
      end)

      assert_file("test/nimble_template/addons/variants/docker_test.exs", fn file ->
        assert file =~ "ELIXIR_IMAGE_VERSION=130.13.4"
      end)
    end

    test "upgrade erlang version given the new erlang_version" do
      assert Version.upgrade_elixir_erlang_node_and_alpine(%{erlang_version: "250.0.1"}) == :ok

      assert_file("lib/nimble_template/projects/project.ex", fn file ->
        assert file =~ "@erlang_version \"250.0.1\""
      end)

      assert_file("test/nimble_template/addons/asdf_tool_version_test.exs", fn file ->
        assert file =~ "erlang 250.0.1"
        assert file =~ "-otp-250"
      end)

      assert_file("test/nimble_template/addons/github_test.exs", fn file ->
        assert file =~ "Erlang 250.0.1"
      end)

      assert_file("test/nimble_template/addons/readme_test.exs", fn file ->
        assert file =~ "Erlang 250.0.1"
      end)

      assert_file("test/nimble_template/addons/variants/docker_test.exs", fn file ->
        assert file =~ "ERLANG_IMAGE_VERSION=250.0.1"
      end)
    end

    test "upgrade node version given the new node_version" do
      assert Version.upgrade_elixir_erlang_node_and_alpine(%{node_version: "180.3.0"}) == :ok

      assert_file("lib/nimble_template/projects/project.ex", fn file ->
        assert file =~ "@node_asdf_version \"180.3.0\""
      end)

      assert_file("test/nimble_template/addons/asdf_tool_version_test.exs", fn file ->
        assert file =~ "nodejs 180.3.0"
      end)

      assert_file("test/nimble_template/addons/github_test.exs", fn file ->
        assert file =~ "Node 180.3.0"
      end)

      assert_file("test/nimble_template/addons/readme_test.exs", fn file ->
        assert file =~ "Node 180.3.0"
      end)
    end

    test "upgrade alpine version given the new alpine_version" do
      assert Version.upgrade_elixir_erlang_node_and_alpine(%{alpine_version: "300.14.6"}) == :ok

      assert_file("lib/nimble_template/projects/project.ex", fn file ->
        assert file =~ "@alpine_version \"300.14.6\""
      end)

      assert_file("test/nimble_template/addons/variants/docker_test.exs", fn file ->
        assert file =~ "RELEASE_IMAGE_VERSION=300.14.6"
      end)
    end
  end
end
