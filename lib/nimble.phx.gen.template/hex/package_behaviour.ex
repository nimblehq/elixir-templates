defmodule Nimble.Phx.Gen.Template.Hex.PackageBehaviour do
  @callback get_latest_version(atom()) :: String.t()
end
