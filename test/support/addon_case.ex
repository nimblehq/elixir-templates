defmodule Nimble.Phx.Gen.Template.AddonCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Nimble.Phx.Gen.Template.Addons

      defp in_test_app(test_app_path, function) do
        try do
          File.cd!(test_app_path, function)
        after
          File.rm_rf!(test_app_path)
        end
      end

      defp assert_file(file) do
        assert File.regular?(file), "Expected #{file} to exist, but does not"
      end

      defp assert_file(file, match) do
        cond do
          is_list(match) ->
            assert_file(file, &Enum.each(match, fn m -> assert &1 =~ m end))

          is_binary(match) or Regex.regex?(match) ->
            assert_file(file, &assert(&1 =~ match))

          is_function(match, 1) ->
            assert_file(file)
            match.(File.read!(file))

          true ->
            raise inspect({file, match})
        end
      end
    end
  end

  setup do
    test_app_path = Path.join(tmp_path(), test_app_path())

    create_new_project(test_app_path)

    {:ok, project: Nimble.Phx.Gen.Template.Project.info(), test_app_path: test_app_path}
  end

  defp create_new_project(project_path) do
    Mix.shell().cmd("printf \"N\n\" | make create_project PROJECT_PATH=#{project_path}")
  end

  defp test_app_path do
    folder_name =
      :crypto.strong_rand_bytes(20)
      |> Base.encode64(padding: false)
      |> String.downcase()

    folder_name <> "/nimble_phx_gen_template"
  end

  defp tmp_path do
    Path.expand("../../tmp", __DIR__)
  end
end
