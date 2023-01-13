defmodule NimbleTemplate.Hex.PackageBehaviour do
  alias NimbleTemplate.Exception.MockHexPackageRequiredException

  @callback get_latest_version(list(String.t())) :: String.t() | MockHexPackageRequiredException
end
