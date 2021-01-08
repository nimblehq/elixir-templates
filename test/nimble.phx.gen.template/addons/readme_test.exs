defmodule Nimble.Phx.Gen.Template.Addons.ReadmeTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    test "copies the README.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Readme.apply(project)

        assert_file("README.md", fn file ->
          assert file =~ "Erlang 23.2.1"
          assert file =~ "Elixir 1.11.3"

          assert file =~ """
                 * Install Node dependencies:

                   ```sh
                   npm install --prefix assets
                   ```
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with api_project" do
    test "copies the README.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true}

      in_test_project(test_project_path, fn ->
        Addons.Readme.apply(project)

        assert_file("README.md", fn file ->
          assert file =~ "Erlang 23.2.1"
          assert file =~ "Elixir 1.11.3"

          refute file =~ """
                 * Install Node dependencies:

                   ```sh
                   npm install --prefix assets
                   ```
                 """
        end)
      end)
    end
  end
end
