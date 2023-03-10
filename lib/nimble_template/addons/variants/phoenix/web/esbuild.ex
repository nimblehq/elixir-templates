defmodule NimbleTemplate.Addons.Phoenix.Web.EsBuild do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> edit_config!()
    |> edit_mix!()
  end

  defp edit_config!(%Project{} = project) do
    Generator.replace_content!("config/config.exs", "default: [", "app: [")

    Generator.replace_content!("config/dev.exs", "[:default", "[:app")

    project
  end

  defp edit_mix!(project) do
    Generator.replace_content_all("mix.exs", "esbuild default", "esbuild app")

    project
  end
end
