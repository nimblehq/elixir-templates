defmodule NimbleTemplate.Addons.Phoenix.MixRelease do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    copy_files(project)

    project
  end

  defp copy_files(
         %Project{otp_app: otp_app, base_module: base_module, base_path: base_path} = project
       ) do
    Generator.copy_file(
      [
        {:eex, "lib/otp_app/release_tasks.ex.eex", base_path <> "/release_tasks.ex"}
      ],
      otp_app: otp_app,
      base_module: base_module
    )

    project
  end
end
