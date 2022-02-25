defmodule NimbleTemplate.AddonHelper do
  def install_addon_prompt?(addon),
    do: Mix.shell().yes?("\nWould you like to add the #{addon} addon?")

  def install_addon_prompt?(addon, %{required_addon: required_addon}),
    do:
      Mix.shell().yes?(
        "\nWould you like to add the #{addon} addon (this addon requires #{required_addon} addon)?"
      )
end
