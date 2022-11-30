defmodule NimbleTemplate.Hex.PackageMock do
  @moduledoc false

  @behaviour NimbleTemplate.Hex.PackageBehaviour

  alias NimbleTemplate.Exception.MockHexPackageRequiredException

  # Prevent the call to get the latest version if the test forgets to mock the external library
  def get_latest_version(package) do
    raise(MockHexPackageRequiredException,
      message:
        "Requires to mock Hex package with `@describetag mock_latest_package_versions: [{#{package}, :version}]`"
    )
  end
end
