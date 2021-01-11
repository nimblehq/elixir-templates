defmodule Nimble.Template.Addons.Docker do
  use Nimble.Template.Addon

  @impl true
  def do_apply(
        %Project{
          web_project?: web_project?,
          otp_app: otp_app,
          base_module: base_module,
          docker_build_base_image: docker_build_base_image,
          docker_app_base_image: docker_app_base_image
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
      docker_build_base_image: docker_build_base_image,
      docker_app_base_image: docker_app_base_image,
      web_project?: web_project?
    )

    Mix.shell().cmd("chmod +x bin/start.sh")

    project
  end
end
