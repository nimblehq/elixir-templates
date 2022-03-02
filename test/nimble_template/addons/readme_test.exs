defmodule NimbleTemplate.Addons.ReadmeTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies the README.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Readme.apply(project)

        assert_file("README.md", fn file ->
          assert file =~ "Erlang 24.2.2"
          assert file =~ "Elixir 1.13.3"

          assert file =~ """
                 - Install Node dependencies:

                   ```sh
                   npm install --prefix assets
                   ```
                 """

          assert file =~ """
                 - Start the Phoenix app

                   ```sh
                   iex -S mix phx.server
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
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Readme.apply(project)

        assert_file("README.md", fn file ->
          assert file =~ "Erlang 24.2.2"
          assert file =~ "Elixir 1.13.3"

          refute file =~ """
                 - Install Node dependencies:

                   ```sh
                   npm install --prefix assets
                   ```
                 """

          assert file =~ """
                 - Start the Phoenix app

                   ```sh
                   iex -S mix phx.server
                   ```
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with mix_project" do
    @describetag mix_project?: true

    test "copies the README.md", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Readme.apply(project)

        assert_file("README.md", fn file ->
          assert file =~ "Erlang 24.2.2"
          assert file =~ "Elixir 1.13.3"

          refute file =~ """
                 - Install Node dependencies:

                   ```sh
                   npm install --prefix assets
                   ```
                 """

          refute file =~ """
                 - Start the Phoenix app

                   ```sh
                   iex -S mix phx.server
                   ```
                 """
        end)
      end)
    end
  end
end
