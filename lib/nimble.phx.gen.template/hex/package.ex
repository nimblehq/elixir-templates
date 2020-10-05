defmodule Nimble.Phx.Gen.Template.Hex.Package do
  def get_latest_version(package) do
    {:ok, package_info} = hex_client(Mix.env()).get("packages/#{package}")

    package_info["releases"] |> List.first() |> Map.get("version")
  end

  defp hex_client(:test), do: Application.get_env(:nimble_phx_gen_template, :hex_client)
  defp hex_client(_env), do: Nimble.Phx.Gen.Template.Hex.HexClient
end
