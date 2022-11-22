defmodule Mix.Tasks.NimbleTemplate.BumpVersion do
  @shortdoc "Bump the template into specific version."

  @moduledoc """
  #{@shortdoc}

  - Hex package: https://hex.pm/packages/nimble_template
  - Github: https://github.com/nimblehq/elixir-templates

  # Usage

  - mix help nimble_template.bump_version # Print help
  - mix nimble_template.bump_version [new_version] # Bump the template version to the [new_version].
  """

  use Mix.Task

  alias NimbleTemplate.Version

  def run(args) do
    new_version = parse_opts(args)

    Version.bump!(new_version)
  end

  defp parse_opts(args) do
    case OptionParser.parse(args, strict: []) do
      {[], [new_version], []} ->
        new_version

      _other ->
        Mix.raise(
          "Invalid command. Check `mix help nimble_template.bump_version` for more information."
        )
    end
  end
end
