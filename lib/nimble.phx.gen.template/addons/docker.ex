defmodule Nimble.Phx.Gen.Template.Addons.Docker do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    copy_files(project)

    project
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:eex, "docker-compose.dev.yml.eex", "docker-compose.dev.yml"}],
      otp_app: project.otp_app
    )
  end
end
