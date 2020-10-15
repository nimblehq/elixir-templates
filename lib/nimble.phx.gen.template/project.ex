defmodule Nimble.Phx.Gen.Template.Project do
  @default_versions %{
    elixir_mix_version: "1.11",
    elixir_asdf_version: "1.11.0-otp-23",
    erlang_asdf_version: "23.1.1"
  }

  defstruct otp_app: nil,
            base_module: nil,
            base_path: nil,
            base_test_path: nil,
            web_module: nil,
            web_path: nil,
            web_test_path: nil,
            api_project?: nil,
            elixir_mix_version: @default_versions[:elixir_mix_version],
            elixir_asdf_version: @default_versions[:elixir_asdf_version],
            erlang_asdf_version: @default_versions[:erlang_asdf_version]

  def new(opts \\ %{}) do
    %__MODULE__{
      api_project?: opts[:api] === true,
      otp_app: Mix.Phoenix.otp_app(),
      base_module: Mix.Phoenix.base(),
      base_path: "lib/" <> Atom.to_string(Mix.Phoenix.otp_app()),
      base_test_path: "test/" <> Atom.to_string(Mix.Phoenix.otp_app()),
      web_module: Mix.Phoenix.base() <> "Web",
      web_path: "lib/" <> Atom.to_string(Mix.Phoenix.otp_app()) <> "_web",
      web_test_path: "test/" <> Atom.to_string(Mix.Phoenix.otp_app()) <> "_web"
    }
  end
end
