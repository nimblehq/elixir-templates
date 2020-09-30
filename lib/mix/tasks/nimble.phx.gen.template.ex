defmodule Mix.Tasks.Nimble.Phx.Gen.Template do
  @shortdoc "Generates Nimble's Phoenix template"

  use Mix.Task

  alias Nimble.Phx.Gen.Template.{Project, Template}

  @version Mix.Project.config()[:version]
  @switches [api: :boolean, web: :boolean]

  def run([version]) when version in ~w(-v --version) do
    Mix.shell().info("Nimble.Phx.Gen.Template v#{@version}")
  end

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix nimble.phx.gen.template can only be run inside an application directory")
    end

    {opts, _params} = parse_opts(args)

    Template.apply(Project.info(opts))
  end

  defp parse_opts(args) do
    case OptionParser.parse(args, strict: @switches) do
      {opts, args, []} ->
        {opts, args}

      {_opts, _args, [switch | _]} ->
        Mix.raise("Invalid option: " <> switch_to_string(switch))
    end
  end

  defp switch_to_string({name, nil}), do: name
  defp switch_to_string({name, val}), do: name <> "=" <> val
end
