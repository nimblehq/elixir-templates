defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleJS do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
  end
end
