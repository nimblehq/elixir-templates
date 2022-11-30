defmodule NimbleTemplate.Hex.PackageMockTest do
  use ExUnit.Case, async: true

  alias NimbleTemplate.Exception.MockHexPackageRequiredException
  alias NimbleTemplate.Hex.PackageMock

  describe "get_latest_version/1" do
    test "raises a MockHexPackageRequiredException" do
      assert_raise MockHexPackageRequiredException, fn ->
        PackageMock.get_latest_version("credo")
      end
    end
  end
end
