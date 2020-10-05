defmodule Nimble.Phx.Gen.Template.Hex.HexClient do
  @behaviour Nimble.Phx.Gen.Template.HttpClient.Behaviour

  @base_url "https://hex.pm/api/"

  def get(path) do
    url = @base_url <> URI.encode(path)

    case http_adapter().get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp http_adapter, do: Application.get_env(:nimble_phx_gen_template, :http_adapter)
end
