defmodule NimbleTemplate.Project do
  @moduledoc false

  @alpine_version "3.13.2"
  @elixir_version "1.11.4"
  @erlang_version "23.3"
  @node_version "14"

  defstruct base_module: nil,
            base_path: nil,
            base_test_path: nil,
            otp_app: nil,
            web_module: nil,
            web_path: nil,
            web_test_path: nil,
            # Dependency Versions
            alpine_version: @alpine_version,
            elixir_version: @elixir_version,
            elixir_asdf_version:
              "#{@elixir_version}-otp-#{@erlang_version |> String.split(".") |> List.first()}",
            erlang_version: @erlang_version,
            node_version: @node_version,
            # Variants
            api_project?: false,
            live_project?: false,
            web_project?: false,
            mix_project?: false

  def new(opts \\ %{}) do
    %__MODULE__{
      base_module: base_module(),
      base_path: "lib/" <> Atom.to_string(otp_app()),
      base_test_path: "test/" <> Atom.to_string(otp_app()),
      otp_app: otp_app(),
      web_module: base_module() <> "Web",
      web_path: "lib/" <> Atom.to_string(otp_app()) <> "_web",
      web_test_path: "test/" <> Atom.to_string(otp_app()) <> "_web",
      api_project?: api_project?(opts),
      web_project?: web_project?(opts),
      live_project?: live_project?(opts),
      mix_project?: mix_project?(opts)
    }
  end

  defp api_project?(opts), do: opts[:api] === true

  defp web_project?(opts), do: opts[:web] === true || opts[:live] === true

  defp live_project?(opts), do: opts[:live] === true

  defp mix_project?(opts), do: opts[:mix] === true

  defp otp_app(), do: Mix.Phoenix.otp_app()

  defp base_module(), do: Mix.Phoenix.base()
end
