defmodule NimbleTemplate.Generator do
  @moduledoc false

  @template_resource "priv/templates/nimble_template"

  def copy_file(files, binding \\ []) do
    Mix.Phoenix.copy_from(
      [:nimble_template],
      @template_resource,
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

    case split_with_self(file_content, anchor) do
      [left, _middle, right] ->
        print_log("* replacing ", Path.relative_to_cwd(file_path))

        File.write!(file, [left, content, right])

      :error ->
        Mix.raise(~s[Could not find #{anchor} in #{file_path}])
    end
  end

  def delete_content(file_path, anchor) do
    replace_content(file_path, anchor, "")
  end

  def inject_content(file_path, anchor, content) do
    file = Path.join([file_path])

    file_content =
      case File.read(file) do
        {:ok, bin} -> bin
        {:error, _} -> Mix.raise(~s[Can't read #{file}])
      end

    case split_with_self(file_content, anchor) do
      [left, middle, right] ->
        print_log("* injecting ", Path.relative_to_cwd(file_path))

        File.write!(file, [left, middle, content, right])

      :error ->
        Mix.raise(~s[Could not find #{anchor} in #{file_path}])
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
        "      " <> inspect(dependency) <> ",\n"
      end)
    )
  end

  def inject_mix_dependency(dependency) do
    inject_content(
      "mix.exs",
      """
        defp deps do
          [
      """,
      "      " <> inspect(dependency) <> ",\n"
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
