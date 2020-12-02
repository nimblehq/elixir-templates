defmodule Nimble.Phx.Gen.Template.Hex.Package do
  alias Nimble.Phx.Gen.Template.Hex.HexClient

  def get_latest_version(package) do
    {:ok, package_info} = HexClient.get("packages/#{package}")

    package_info["releases"] |> List.first() |> Map.get("version")
  end
end
