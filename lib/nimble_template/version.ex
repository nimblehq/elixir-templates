defmodule NimbleTemplate.Version do
  @moduledoc false

  alias NimbleTemplate.Generator

  def bump(new_version) do
    current_version = Mix.Project.config()[:version]

    if new_version > current_version do
      bump_version_to(current_version, new_version)

      :ok
    else
      Mix.raise("The new version must be greater than #{current_version}")
    end
  end

  defp bump_version_to(current_version, new_version) do
    Generator.replace_content(
      "mix.exs",
      "version: \"#{current_version}\",",
      "version: \"#{new_version}\","
    )

    Generator.replace_content(
      "README.md",
      "{:nimble_template, \"~> #{current_version}\", only: :dev, runtime: false},",
      "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"
    )
  end
end
