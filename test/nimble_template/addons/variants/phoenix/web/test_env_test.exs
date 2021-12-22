defmodule NimbleTemplate.Addons.Phoenix.Web.TestEnvTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    @describetag required_addons: [:TestEnv]

    test "adds eslint.fix and stylelint.fix into the codebase.fix alias", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.TestEnv.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                       "codebase.fix": [
                         \"deps.clean --unlock --unused\",
                         \"format\",
                         \"cmd npm run eslint.fix --prefix assets\",
                         \"cmd npm run stylelint.fix --prefix assets\"
                       ],
                 """
        end)
      end)
    end
  end
end
