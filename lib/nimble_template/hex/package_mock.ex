defmodule NimbleTemplate.Hex.PackageMock do
  @moduledoc false

  @behaviour NimbleTemplate.Hex.PackageBehaviour

  alias NimbleTemplate.Exception.MockHexPackageRequiredException

  def get_latest_version(package) do
    raise(MockHexPackageRequiredException,
      message:
        "Mock Hex Package with `@describetag mock_latest_package_versions: [{#{package}, :version}]` required"
    )
  end
end
