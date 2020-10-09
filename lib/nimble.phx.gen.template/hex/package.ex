defmodule Nimble.Phx.Gen.Template.Hex.Package do
  @behaviour Nimble.Phx.Gen.Template.Hex.PackageBehaviour

  alias Nimble.Phx.Gen.Template.Hex.HexClient

  @impl true
  def get_latest_version(package) do
    {:ok, package_info} = HexClient.get("packages/#{package}")

    package_info["releases"] |> List.first() |> Map.get("version")
  end
end
