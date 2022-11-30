defmodule NimbleTemplate.Addons.Addon do
  @moduledoc false

  alias __MODULE__
  alias NimbleTemplate.Projects.Project

  @callback apply!(%Project{}, %{}) :: %Project{}
  @callback do_apply!(%Project{}, %{}) :: %Project{}

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour Addon

      import NimbleTemplate.GithubHelper, only: [has_github_wiki_directory?: 0]

      alias NimbleTemplate.Generator
      alias NimbleTemplate.Hex.Package
      alias NimbleTemplate.Projects.Project
      alias NimbleTemplate.ProjectHelper

      def apply!(%Project{} = project, opts \\ %{}) when is_map(opts) do
        Generator.info_log("* applying ", inspect(__MODULE__))

        project
        |> do_apply!(opts)
        |> ProjectHelper.append_installed_addon(__MODULE__)
      end

      def do_apply!(%Project{} = project, opts) when is_map(opts), do: project

      defp latest_package_version(package),
        do: "~> " <> hex_package_resource().get_latest_version(package)

      # TODO: `Application.get_env(:nimble_template, :hex_package_resource)` returns nil on runtime, temporary fix by fallback to `Package`
      defp hex_package_resource,
        do: Application.get_env(:nimble_template, :hex_package_resource, Package)

      defoverridable do_apply!: 2
    end
  end
end
