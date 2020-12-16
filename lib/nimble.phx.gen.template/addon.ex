defmodule Nimble.Phx.Gen.Template.Addon do
  alias Nimble.Phx.Gen.Template.{Addon, Project}

  @callback apply(%Project{}, %{}) :: %Project{}
  @callback do_apply(%Project{}, %{}) :: %Project{}

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour Addon

      alias Nimble.Phx.Gen.Template.{Generator, Project}
      alias Nimble.Phx.Gen.Template.Hex.Package

      def apply(%Project{} = project, opts \\ %{}) when is_map(opts) do
        Generator.print_log("* applying ", inspect(__MODULE__))

        do_apply(project, opts)
      end

      def do_apply(%Project{} = project, opts) when is_map(opts), do: project

      defp latest_package_version(package) do
        "~> " <> Package.get_latest_version(package)
      end

      defoverridable do_apply: 2
    end
  end
end
