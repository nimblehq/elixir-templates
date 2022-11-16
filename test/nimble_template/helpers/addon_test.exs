defmodule NimbleTemplate.AddonTest do
  use NimbleTemplate.AddonCase, async: false

  import ExUnit.CaptureIO

  alias NimbleTemplate.AddonHelper
  alias NimbleTemplate.Projects.Project

  describe "install_addon_prompt/3" do
    test "when response prompt with 'Y', prepends the addon to the project", %{project: project} do
      display_prompt =
        capture_io([input: "Y\n"], fn ->
          project =
            project
            |> Project.prepend_optional_addon(NimbleTemplate.Addons.FirstAddon)
            |> AddonHelper.install_addon_prompt(NimbleTemplate.Addons.SecondAddon)

          assert project.optional_addons == [
                   NimbleTemplate.Addons.SecondAddon,
                   NimbleTemplate.Addons.FirstAddon
                 ]
        end)

      assert display_prompt =~ "Would you like to add the SecondAddon addon? [Yn]"
    end

    test "when response prompt with 'N', does not prepend the addon to the project", %{
      project: project
    } do
      display_prompt =
        capture_io([input: "N\n"], fn ->
          project =
            project
            |> Project.prepend_optional_addon(NimbleTemplate.Addons.FirstAddon)
            |> AddonHelper.install_addon_prompt(NimbleTemplate.Addons.SecondAddon)

          assert project.optional_addons == [
                   NimbleTemplate.Addons.FirstAddon
                 ]
        end)

      assert display_prompt =~ "Would you like to add the SecondAddon addon? [Yn]"
    end

    test "given addon label, shows prompts with the given label", %{
      project: project
    } do
      display_prompt =
        capture_io(fn ->
          AddonHelper.install_addon_prompt(
            project,
            NimbleTemplate.Addons.FirstAddon,
            "Custom addon name"
          )
        end)

      assert display_prompt =~ "Would you like to add the Custom addon name addon? [Yn]"
    end
  end
end
