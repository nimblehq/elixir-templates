defmodule NimbleTemplate.VersionTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.Version

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
      end)

      assert_file("README.md", fn file ->
        assert file =~ "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"
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
        refute file =~ "version: \"#{new_version}\""
      end)

      assert_file("README.md", fn file ->
        refute file =~ "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"
      end)
    end
  end
end
