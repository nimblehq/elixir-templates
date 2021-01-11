defmodule NimbleTemplate.Hex.Package do
  alias NimbleTemplate.Hex.HexClient

  def get_latest_version(package) do
    {:ok, package_info} = HexClient.get("packages/#{package}")

    package_info["releases"] |> List.first() |> Map.get("version")
  end
end
