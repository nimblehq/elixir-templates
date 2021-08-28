defmodule NimbleTemplate.AddonHelper do
  def install_addon_prompt?(addon),
    do: Mix.shell().yes?("\nWould you like to add the #{addon} addon?")
end
