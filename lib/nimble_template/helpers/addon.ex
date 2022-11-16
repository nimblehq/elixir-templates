defmodule NimbleTemplate.AddonHelper do
  alias NimbleTemplate.Projects.Project

  @spec install_addon_prompt(Project.t(), atom(), String.t() | nil) :: Project.t()
  def install_addon_prompt(project, addon, addon_label \\ nil) do
    if Mix.shell().yes?(
         "\nWould you like to add the #{build_addon_label(addon, addon_label)} addon?"
       ) do
      Project.prepend_optional_addon(project, addon)
    else
      project
    end
  end

  defp build_addon_label(addon, nil) do
    addon
    |> Module.split()
    |> List.last()
  end

  defp build_addon_label(_addon, addon_label), do: addon_label
end
