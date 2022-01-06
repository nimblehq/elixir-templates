defmodule Mix.Tasks.NimbleTemplate.Gen do
  @shortdoc "Apply Nimble's Elixir/Phoenix template"

  @moduledoc """
  #{@shortdoc}

  - Hex package: https://hex.pm/packages/nimble_template
  - Github: https://github.com/nimblehq/elixir-templates

  # Usage

  - mix help nimble_template.gen # Print help
  - mix nimble_template.gen -v # Print the version

  ### Phoenix application

  - mix nimble_template.gen --api # Apply the Phoenix API template
  - mix nimble_template.gen --live # Apply the Phoenix LiveView template
  - mix nimble_template.gen --web # Apply the Phoenix Web template

  ### Non-Phoenix application

  - mix nimble_template.gen --mix # Apply the Mix template
  """

  use Mix.Task

  alias NimbleTemplate.Projects.Project
  alias NimbleTemplate.Templates.Template

  @version Mix.Project.config()[:version]
  @variants [api: :boolean, web: :boolean, live: :boolean, mix: :boolean]

  def run([args]) when args in ~w(-v --version), do: Mix.shell().info("NimbleTemplate v#{@version}")

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix nimble_template.gen can only be run inside an application directory")
    end

    {opts, _params} = parse_opts(args)

    {:ok, _} = Application.ensure_all_started(:httpoison)

    Template.apply(Project.new(opts))
  end

  defp parse_opts(args) do
    case OptionParser.parse(args, strict: @variants) do
      {opts, args, []} ->
        {opts, args}

      {_opts, _args, [switch | _]} ->
        Mix.raise("Invalid option: " <> humanize_variant_option(switch))
    end
  end

  defp humanize_variant_option({name, nil}), do: name
  defp humanize_variant_option({name, val}), do: name <> "=" <> val
end
