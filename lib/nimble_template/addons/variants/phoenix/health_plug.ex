defmodule NimbleTemplate.Addons.Phoenix.HealthPlug do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(
         %Project{
           web_module: web_module,
           base_module: base_module,
           web_path: web_path,
           web_test_path: web_test_path
         } = project
       ) do
    binding = [
      web_module: web_module,
      base_module: base_module
    ]

    files = [
      {:eex, "lib/otp_app_web/plugs/health_plug.ex.eex", "#{web_path}/plugs/health_plug.ex"},
      {:eex, "test/otp_app_web/plugs/health_plug_test.exs.eex",
       "#{web_test_path}/plugs/health_plug_test.exs"}
    ]

    Generator.copy_file(files, binding)

    project
  end

  defp edit_files(project) do
    project
    # |> edit_router()
    # |> edit_config()
    # |> edit_wiki_sidebar()
  end
end
