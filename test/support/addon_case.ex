defmodule Nimble.Phx.Gen.Template.AddonCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Nimble.Phx.Gen.Template.Addons

      # ATTENTION: File.cd! doesn't support `async: true`, the test will fail randomly in async mode
      # https://elixirforum.com/t/randomly-getting-compilationerror-on-tests/17298/3
      defp in_test_project(test_project_path, function), do: File.cd!(test_project_path, function)

      defp assert_file(path),
        do: assert(File.regular?(path), "Expected #{path} to exist, but does not")

      defp assert_file(path, match) do
        assert_file(path)
        match.(File.read!(path))
      end
    end
  end

  setup do
    parent_test_project_path = Path.join(tmp_path(), parent_test_project_path())
    test_project_path = Path.join(parent_test_project_path, "/nimble_phx_gen_template")

    create_test_project(test_project_path)

    on_exit(fn ->
      File.rm_rf!(parent_test_project_path)
    end)

    {:ok, project: Nimble.Phx.Gen.Template.Project.info(), test_project_path: test_project_path}
  end

  defp create_test_project(test_project_path),
    do:
      Mix.shell().cmd(
        "printf \"N\n\" | make create_project PROJECT_PATH=#{test_project_path} > /dev/null"
      )

  defp parent_test_project_path do
    :crypto.strong_rand_bytes(20)
    |> Base.url_encode64(padding: false)
    |> String.downcase()
  end

  defp tmp_path, do: Path.expand("../../tmp", __DIR__)
end