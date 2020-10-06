defmodule Nimble.Phx.Gen.Template.Addons.Docker do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{otp_app: otp_app} = project, _opts) do
    Generator.copy_file([{:eex, "docker-compose.dev.yml.eex", "docker-compose.dev.yml"}],
      otp_app: otp_app
    )

    project
  end
end
