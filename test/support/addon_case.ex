defmodule Nimble.Template.AddonCase do
  use ExUnit.CaseTemplate

  use Mimic

  alias Nimble.Template.Addons.Web, as: AddonsWeb
  alias Nimble.Template.{Addons, Project}
  alias Nimble.Template.Hex.Package

  using do
    quote do
      alias Nimble.Template.Addons
      alias Nimble.Template.Addons.Web, as: AddonsWeb

      # ATTENTION: File.cd! doesn't support `async: true`, the test will fail randomly in async mode
      # https://elixirforum.com/t/randomly-getting-compilationerror-on-tests/17298/3
      defp in_test_project(test_project_path, function), do: File.cd!(test_project_path, function)

      defp assert_file(path),
        do: assert(File.regular?(path), "Expected #{path} to exist, but does not")

      defp assert_file(path, match) do
        assert_file(path)
        match.(File.read!(path))
      end

      defp refute_file(path),
        do: refute(File.regular?(path), "Expected #{path} does not exist, but it does")
    end
  end

  setup context do
    parent_test_project_path = Path.join(tmp_path(), parent_test_project_path())
    test_project_path = Path.join(parent_test_project_path, "/nimble_template")

    project =
      if context[:mix_project?] == true do
        create_mix_test_project(test_project_path)

        Project.new(mix: true)
      else
        create_phoenix_test_project(test_project_path)

        # Set Web Project as default, switch to either API or Live Project in each test case
        # eg: project = %{project | api_project?: true, web_project?: false}
        Project.new(web: true)
      end

    on_exit(fn ->
      File.rm_rf!(parent_test_project_path)
    end)

    if mock_latest_package_versions = context[:mock_latest_package_versions] do
      Enum.each(mock_latest_package_versions, &mock_latest_package_version(&1))
    end

    if required_addons = context[:required_addons] do
      File.cd!(test_project_path, fn ->
        Enum.each(required_addons, &Module.safe_concat([Addons, &1]).apply(project))
      end)
    end

    {:ok, project: project, test_project_path: test_project_path}
  end

  defp mock_latest_package_version({_package, version}),
    do: expect(Package, :get_latest_version, fn _package -> version end)

  defp create_phoenix_test_project(test_project_path) do
    # N - in response to Fetch and install dependencies?
    Mix.shell().cmd(
      "printf \"N\n\" | make create_phoenix_project PROJECT_DIRECTORY=#{test_project_path} > /dev/null"
    )
  end

  defp create_mix_test_project(test_project_path) do
    # N - in response to Fetch and install dependencies?
    Mix.shell().cmd(
      "printf \"N\n\" | make create_mix_project PROJECT_DIRECTORY=#{test_project_path} > /dev/null"
    )
  end

  defp parent_test_project_path do
    20
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
    |> String.downcase()
  end

  defp tmp_path, do: Path.expand("../../tmp", __DIR__)
end
