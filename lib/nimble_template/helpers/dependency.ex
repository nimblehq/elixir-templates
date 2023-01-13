defmodule NimbleTemplate.DependencyHelper do
  alias NimbleTemplate.Generator

  def order_dependencies! do
    file_content = File.read!("mix.exs")

    dependencies = extract_dependencies(file_content)

    ordered_dependencies =
      dependencies
      |> String.split(",\n")
      |> Enum.sort()
      |> Enum.join(",\n")

    Generator.replace_content!("mix.exs", dependencies, ordered_dependencies)
  end

  defp extract_dependencies(contents) do
    [_, deps_with_file_footer] =
      String.split(contents, """
        defp deps do
          [
      """)

    [deps | _footer] = String.split(deps_with_file_footer, "\n    ]\n  end")

    deps
  end
end
