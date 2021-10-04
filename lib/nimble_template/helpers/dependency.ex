defmodule NimbleTemplate.DependencyHelper do
  alias NimbleTemplate.Generator

  def fetch_and_install_dependencies,
    do:
      if(Mix.shell().yes?("\nFetch and install dependencies?"), do: Mix.shell().cmd("mix deps.get"))

  def order_dependencies! do
    file_content = File.read!("mix.exs")

    dependencies = extract_dependencies(file_content)

    ordered_dependencies =
      dependencies
      |> String.split(",\n")
      |> Enum.sort()
      |> Enum.join(",\n")

    Generator.replace_content("mix.exs", dependencies, ordered_dependencies)
  end

  def extract_dependencies(contents) do
    [_, deps_with_file_footer] =
      :binary.split(contents, """
        defp deps do
          [
      """)

    [deps, _footer] = :binary.split(deps_with_file_footer, "\n    ]\n  end")

    deps
  end
end
