defmodule Nimble.Phx.Gen.Template.Addons.MakefileTest do
  use Nimble.Phx.Gen.Template.AddonCase, async: true

  describe "#apply/2" do
    @tag timeout: :infinity
    test "copies the Makefile into the project", %{project: _project} do
      # Addons.Makefile.apply(project, {})

      # assert File.regular?("Makefile") === true
    end
  end
end
