defmodule Nimble.Phx.Gen.Template.Addons.Dialyxir do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    dialyxir: "~> 1.0"
  }

  @impl true
  def do_apply(%Project{} = project, _opts) do
    Generator.inject_mix_dependency({:dialyxir, @versions.dialyxir, only: [:dev], runtime: false})

    project
  end
end
