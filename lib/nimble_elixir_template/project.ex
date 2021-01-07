defmodule Nimble.Elixir.Template.Project do
  # Erlang versions: asdf list all erlang
  # Elixir versions: asdf list all elixir
  @default_versions %{
    erlang_asdf_version: "23.2.1",
    elixir_asdf_version: "1.11.3-otp-23",
    elixir_mix_version: "1.11.3"
  }

  # Elixir image tags: https://hub.docker.com/r/hexpm/elixir/tags
  @docker_base_images %{
    build: "hexpm/elixir:1.11.3-erlang-23.2.1-alpine-3.12.1",
    app: "alpine:3.12.1"
  }

  defstruct otp_app: nil,
            base_module: nil,
            base_path: nil,
            base_test_path: nil,
            web_module: nil,
            web_path: nil,
            web_test_path: nil,
            api_project?: false,
            web_project?: false,
            live_project?: false,
            erlang_asdf_version: @default_versions[:erlang_asdf_version],
            elixir_asdf_version: @default_versions[:elixir_asdf_version],
            elixir_mix_version: @default_versions[:elixir_mix_version],
            docker_build_base_image: @docker_base_images[:build],
            docker_app_base_image: @docker_base_images[:app]

  def new(opts \\ %{}) do
    %__MODULE__{
      api_project?: api_project?(opts),
      web_project?: web_project?(opts),
      live_project?: live_project?(opts),
      otp_app: otp_app(),
      base_module: base_module(),
      base_path: "lib/" <> Atom.to_string(otp_app()),
      base_test_path: "test/" <> Atom.to_string(otp_app()),
      web_module: base_module() <> "Web",
      web_path: "lib/" <> Atom.to_string(otp_app()) <> "_web",
      web_test_path: "test/" <> Atom.to_string(otp_app()) <> "_web"
    }
  end

  defp api_project?(opts), do: opts[:api] === true

  defp web_project?(opts), do: opts[:web] === true || opts[:live] === true

  defp live_project?(opts), do: opts[:live] === true

  defp otp_app(), do: Mix.Phoenix.otp_app()

  defp base_module(), do: Mix.Phoenix.base()
end
