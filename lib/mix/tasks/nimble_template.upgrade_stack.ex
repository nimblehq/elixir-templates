defmodule Mix.Tasks.NimbleTemplate.UpgradeStack do
  @shortdoc "Upgrade Elixir, Erlang, Alpine or Node version."

  @moduledoc """
  #{@shortdoc}

  - Hex package: https://hex.pm/packages/nimble_template
  - Github: https://github.com/nimblehq/elixir-templates

  # Usage

  - mix help nimble_template.upgrade_stack # Print help
  - mix nimble_template.upgrade_stack elixir x.x.x # Upgrade Elixir to x.x.x
  - mix nimble_template.upgrade_stack erlang x.x.x # Upgrade Erlang to x.x.x
  - mix nimble_template.upgrade_stack alpine x.x.x # Upgrade Alpine to x.x.x
  - mix nimble_template.upgrade_stack node x.x.x # Upgrade Node to x.x.x
  - mix nimble_template.upgrade_stack elixir x.x.x erlang y.y.y alpine z.z.z node w.w.w # Upgrade Elixir, Erlang, Alpine and Node
  """

  use Mix.Task

  alias NimbleTemplate.Version

  def run(args) do
    stack_versions = parse_opts(args)

    Version.upgrade_stack(stack_versions)
  end

  defp parse_opts(args) do
    case OptionParser.parse(args,
           strict: [
             elixir: :string,
             erlang: :string,
             alpine: :string,
             node: :string
           ]
         ) do
      {stack_versions, _, _} ->
        stack_versions

      _other ->
        Mix.raise(
          "Invalid command. Check `mix help nimble_template.upgrade_stack` for more information."
        )
    end
  end
end
