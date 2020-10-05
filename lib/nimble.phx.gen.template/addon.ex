defmodule Nimble.Phx.Gen.Template.Addon do
  alias Nimble.Phx.Gen.Template.{Addon, Project}

  @callback apply(%Project{}, %{}) :: %Project{}
  @callback do_apply(%Project{}, %{}) :: %Project{}

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour Addon

      alias Nimble.Phx.Gen.Template.{Generator, Project}

      def apply(%Project{} = project, opts \\ %{}) when is_map(opts) do
        Generator.print_log("* applying ", inspect(__MODULE__))

        do_apply(project, opts)
      end

      def do_apply(%Project{} = project, opts) when is_map(opts), do: project

      defp package_version(package) do
        "~> " <> hex_package(Mix.env()).get_latest_version(package)
      end

      defp hex_package(:test), do: Application.get_env(:nimble_phx_gen_template, :hex_package)
      defp hex_package(_env), do: Nimble.Phx.Gen.Template.Hex.Package

      defoverridable do_apply: 2
    end
  end
end
