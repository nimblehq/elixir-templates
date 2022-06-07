defmodule Mix.Tasks.NimbleTemplate.BumpVersion do
  @shortdoc "Bump the template into specific version."

  @moduledoc """
  #{@shortdoc}

  - Hex package: https://hex.pm/packages/nimble_template
  - Github: https://github.com/nimblehq/elixir-templates

  # Usage

  - mix help nimble_template.bump_version # Print help
  - mix nimble_template.bump_version [new_version] # Bump the template into the [new_version].
  """

  use Mix.Task

  alias NimbleTemplate.Version

  def run(args) do
    new_version = parse_opts(args)

    Version.bump(new_version, %{included_git_action?: true})
  end

  defp parse_opts(args) do
    case OptionParser.parse(args, strict: []) do
      {[], [new_version], []} ->
        new_version

      _ ->
        Mix.raise("Invalid format. Please use `mix nimble_template.bump_version new_version`")
    end
  end
end
