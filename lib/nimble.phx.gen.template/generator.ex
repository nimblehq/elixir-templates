defmodule Nimble.Phx.Gen.Template.Generator do
  def copy_file(files, binding \\ []) do
    Mix.Phoenix.copy_from(
      [:nimble_phx_gen_template],
      "priv/templates/nimble.phx.gen.template",
      binding,
      files
    )
  end

  def replace_content(file_path, anchor, content) do
    file = Path.join([file_path])

    file_content =
      case File.read(file) do
        {:ok, bin} -> bin
        {:error, _} -> Mix.raise(~s[Can't read #{file}])
      end

    with :error <- split_with_self(file_content, anchor) do
      Mix.raise(~s[Could not find #{anchor} in #{file_path}])
    else
      [left, _middle, right] ->
        print_log("* replacing ", Path.relative_to_cwd(file_path))

        File.write!(file, [left, content, right])
    end
  end

  def inject_content(file_path, anchor, content) do
    file = Path.join([file_path])

    file_content =
      case File.read(file) do
        {:ok, bin} -> bin
        {:error, _} -> Mix.raise(~s[Can't read #{file}])
      end

    with :error <- split_with_self(file_content, anchor) do
      Mix.raise(~s[Could not find #{anchor} in #{file_path}])
    else
      [left, middle, right] ->
        print_log("* injecting ", Path.relative_to_cwd(file_path))

        File.write!(file, [left, middle, content, right])
    end
  end

  def inject_mix_dependency(dependencies) when is_list(dependencies) do
    inject_content(
      "mix.exs",
      """
        defp deps do
          [
      """,
      Enum.map(dependencies, fn dependency ->
        "      " <> inspect(dependency) <> ","
      end)
      |> Enum.join("\n")
    )
  end

  def inject_mix_dependency(dependency) do
    inject_content(
      "mix.exs",
      """
        defp deps do
          [
      """,
      "      " <> inspect(dependency) <> "," <> "\n"
    )
  end

  def print_log(prefix, content \\ ""), do: Mix.shell().info([:green, prefix, :reset, content])

  defp split_with_self(contents, text) do
    case :binary.split(contents, text) do
      [left, right] -> [left, text, right]
      [_] -> :error
    end
  end
end
