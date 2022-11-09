defmodule NimbleTemplate.Exception.MockHexPackageRequiredException do
  defexception message:
                 "Mock Hex Package with `@describetag mock_latest_package_versions: [{name, version}]` required"
end
