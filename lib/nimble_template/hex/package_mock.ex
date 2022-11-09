defmodule NimbleTemplate.Hex.PackageMock do
  @moduledoc false

  @behaviour NimbleTemplate.Hex.PackageBehaviour

  alias NimbleTemplate.Exception.MockHexPackageRequiredException

  def get_latest_version(_package), do: raise(MockHexPackageRequiredException)
end
