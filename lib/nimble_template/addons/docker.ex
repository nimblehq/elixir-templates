defmodule NimbleTemplate.Addons.Docker do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(
        %Project{
          web_project?: web_project?,
          otp_app: otp_app,
          base_module: base_module,
          alpine_version: alpine_version,
          elixir_version: elixir_version,
          erlang_version: erlang_version
        } = project,
        _opts
      ) do
    Generator.copy_file(
      [
        {:eex, "docker-compose.dev.yml.eex", "docker-compose.dev.yml"},
        {:eex, "docker-compose.yml.eex", "docker-compose.yml"},
        {:eex, "Dockerfile.eex", "Dockerfile"},
        {:eex, "bin/start.sh.eex", "bin/start.sh"},
        {:text, ".dockerignore", ".dockerignore"}
      ],
      otp_app: otp_app,
      base_module: base_module,
      alpine_version: alpine_version,
      elixir_version: elixir_version,
      erlang_version: erlang_version,
      web_project?: web_project?
    )

    Mix.shell().cmd("chmod +x bin/start.sh")

    project
  end
end
