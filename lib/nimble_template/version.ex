defmodule NimbleTemplate.Version do
  @moduledoc false

  alias NimbleTemplate.Generator

  def bump(new_version, opts \\ %{}) do
    current_version = Mix.Project.config()[:version]

    if new_version > current_version do
      if included_git_action?(opts) do
        git_checkout_chore_branch(new_version)
      end

      bump_version_to(current_version, new_version)

      if included_git_action?(opts) do
        git_add_and_push(new_version)
      end

      :ok
    else
      Mix.raise("The new version must be greater than #{current_version}")
    end
  end

  defp included_git_action?(%{included_git_action?: true}), do: true
  defp included_git_action?(_opts), do: false

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

  defp git_checkout_chore_branch(new_version) do
    Mix.shell().cmd("git checkout develop")
    Mix.shell().cmd("git checkout -b chore/bump-to-#{new_version}")
  end

  defp git_add_and_push(new_version) do
    Mix.shell().cmd("git add mix.exs README.md")
    Mix.shell().cmd("git commit -m \"Bump to #{new_version}\"")
  end
end
