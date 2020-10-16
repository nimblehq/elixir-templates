defmodule Nimble.Phx.Gen.Template.Project do
  # Erlang versions: asdf list all erlang
  # Elixir versions: asdf list all elixir
  @default_versions %{
    erlang_asdf_version: "23.1.1",
    elixir_asdf_version: "1.11.1-otp-23",
    elixir_mix_version: "1.11"
  }

  # Elixir image tags: https://hub.docker.com/r/hexpm/elixir/tags
  @docker_base_images %{
    build: "hexpm/elixir:1.11.1-erlang-23.1.1-alpine-3.12.0",
    app: "alpine:3.12.0"
  }

  defstruct otp_app: nil,
            base_module: nil,
            base_path: nil,
            base_test_path: nil,
            web_module: nil,
            web_path: nil,
            web_test_path: nil,
            api_project?: nil,
            erlang_asdf_version: @default_versions[:erlang_asdf_version],
            elixir_asdf_version: @default_versions[:elixir_asdf_version],
            elixir_mix_version: @default_versions[:elixir_mix_version],
            docker_build_base_image: @docker_base_images[:build],
            docker_app_base_image: @docker_base_images[:app]

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
