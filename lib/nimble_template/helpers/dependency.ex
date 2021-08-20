defmodule NimbleTemplate.DependencyHelper do
  def fetch_and_install_dependencies(),
    do:
      if(Mix.shell().yes?("\nFetch and install dependencies?"), do: Mix.shell().cmd("mix deps.get"))
end
