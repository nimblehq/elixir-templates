defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleCSS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
  end
end
