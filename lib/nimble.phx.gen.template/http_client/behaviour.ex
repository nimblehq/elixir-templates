defmodule Nimble.Phx.Gen.Template.HttpClient.Behaviour do
  @callback get(String.t()) :: {:ok, body :: term()} | {:error, reason :: String.t()}
end
