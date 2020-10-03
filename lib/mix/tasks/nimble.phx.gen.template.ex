defmodule Mix.Tasks.Nimble.Phx.Gen.Template do
  @shortdoc "Generates Nimble's Phoenix template"

  use Mix.Task

  alias Nimble.Phx.Gen.Template.{Project, Template}

  @version Mix.Project.config()[:version]
  @variants [api: :boolean, web: :boolean]

  def run([args]) when args in ~w(-v --version) do
    Mix.shell().info("Nimble.Phx.Gen.Template v#{@version}")
  end

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix nimble.phx.gen.template can only be run inside an application directory")
    end

    {opts, _params} = parse_opts(args)

    %Project{
      api_project?: opts[:api] === true,
      otp_app: Mix.Phoenix.otp_app(),
      base_module: Mix.Phoenix.base(),
      base_path: "lib/" <> Atom.to_string(Mix.Phoenix.otp_app()),
      base_test_path: "test/" <> Atom.to_string(Mix.Phoenix.otp_app()),
      web_module: Mix.Phoenix.base() <> "Web",
      web_path: "lib/" <> Atom.to_string(Mix.Phoenix.otp_app()) <> "_web",
      web_test_path: "test/" <> Atom.to_string(Mix.Phoenix.otp_app()) <> "_web"
    }
    |> Template.apply()
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
