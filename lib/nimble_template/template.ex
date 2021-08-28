defmodule NimbleTemplate.Template do
  @moduledoc false

  import NimbleTemplate.DependencyHelper

  alias NimbleTemplate.Mix.Template, as: MixTemplate
  alias NimbleTemplate.Phoenix.Template, as: PhoenixTemplate
  alias NimbleTemplate.Project

  def apply(%Project{mix_project?: true} = project) do
    MixTemplate.apply(project)

    fetch_and_install_dependencies()
  end

  def apply(%Project{} = project) do
    PhoenixTemplate.apply(project)

    fetch_and_install_dependencies()
  end
end
