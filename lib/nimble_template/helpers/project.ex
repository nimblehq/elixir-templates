defmodule NimbleTemplate.ProjectHelper do
  alias NimbleTemplate.Projects.Project

  def append_installed_addon(
        %Project{installed_addons: existing_installed_addons} = project,
        new_addon_module_name
      ) do
    Map.put(project, :installed_addons, [new_addon_module_name | existing_installed_addons])
  end

  def prepend_addon(
        %Project{addons: existing_addons} = project,
        addon_module
      ) do
    Map.put(project, :addons, [addon_module | existing_addons])
  end
end
