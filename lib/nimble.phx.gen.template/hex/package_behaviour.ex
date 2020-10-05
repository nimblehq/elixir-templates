defmodule Nimble.Phx.Gen.Template.Hex.PackageBehaviour do
  @callback get_latest_version(String.t()) :: String.t()
end
