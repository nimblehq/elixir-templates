defmodule Nimble.Template.ReleaseVersionTest do
  use ExUnit.Case, async: true

  alias Nimble.Template.Hex.Package

  @tag :release_version
  test "the new version is greater than the hex version" do
    new_version = Mix.Project.config()[:version]
    hex_version = Package.get_latest_version("nimble_template")

    assert new_version > hex_version
  end
end
