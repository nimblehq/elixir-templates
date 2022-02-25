defmodule NimbleTemplate.AddonCase do
  use ExUnit.CaseTemplate

  use Mimic

  alias NimbleTemplate.Addons
  alias NimbleTemplate.Addons.Phoenix.Api, as: ApiAddons
  alias NimbleTemplate.Addons.Phoenix.Web, as: WebAddons
  alias NimbleTemplate.Hex.Package
  alias NimbleTemplate.Projects.Project

  using do
    quote do
      alias NimbleTemplate.Addons
      alias NimbleTemplate.Addons.Phoenix, as: PhoenixAddons
      alias NimbleTemplate.Addons.Phoenix.Api, as: ApiAddons
      alias NimbleTemplate.Addons.Phoenix.Web, as: WebAddons

      # ATTENTION: File.cd! doesn't support `async: true`, the test will fail randomly in async mode
      # https://elixirforum.com/t/randomly-getting-compilationerror-on-tests/17298/3
      defp in_test_project(test_project_path, function), do: File.cd!(test_project_path, function)

      defp assert_file(path),
        do: assert(File.regular?(path), "Expected #{path} to exist, but does not")

      defp assert_directory(path),
        do: assert(File.dir?(path), "Expected #{path} to exist, but does not")

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
      cond do
        context[:mix_project?] == true ->
          create_mix_test_project(test_project_path)

          Project.new(mix: true)

        context[:live_project?] == true ->
          create_phoenix_test_project(test_project_path)

          Project.new(web: true, live: true)

        true ->
          create_phoenix_test_project(test_project_path, "--no-live")

          # Set Web Project as default, switch to API in each test case
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
        Enum.each(required_addons, &apply_required_addon(&1, project))
      end)
    end

    {:ok, project: project, test_project_path: test_project_path}
  end

  defp apply_required_addon(required_addon, project) when is_atom(required_addon),
    do: Module.safe_concat([Addons, required_addon]).apply(project)

  defp apply_required_addon({required_addon_module, required_addon_opt}, project),
    do: Module.safe_concat([Addons, required_addon_module]).apply(project, required_addon_opt)

  defp mock_latest_package_version({_package, version}),
    do: expect(Package, :get_latest_version, fn _package -> version end)

  defp create_phoenix_test_project(test_project_path, opts \\ "") do
    # N - in response to Fetch and install dependencies?
    Mix.shell().cmd(
      "printf \"N\n\" | make create_phoenix_project PROJECT_DIRECTORY=#{test_project_path} OPTIONS=#{opts} > /dev/null"
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
