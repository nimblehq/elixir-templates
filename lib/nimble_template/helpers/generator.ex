defmodule NimbleTemplate.Generator do
  @moduledoc false

  @template_resource "priv/templates/nimble_template"

  def copy_directory(source_path, target_path, binding \\ []) do
    root = Application.app_dir(:nimble_template, @template_resource)

    "#{root}/#{source_path}/**/*"
    |> Path.wildcard(match_dot: true)
    |> Enum.reject(&File.dir?/1)
    |> Enum.map(&String.replace(&1, "#{root}/", ""))
    |> Enum.each(&copy_file([{:text, &1, String.replace(&1, source_path, target_path)}], binding))
  end

  def copy_file(files, binding \\ []) do
    Mix.Phoenix.copy_from(
      [:nimble_template],
      @template_resource,
      binding,
      files
    )
  end

  def rename_file(old_path, new_path), do: File.rename(old_path, new_path)

  def replace_content(file_path, anchor, content, raise_exception \\ true) do
    file = Path.join([file_path])

    file_content =
      case File.read(file) do
        {:ok, bin} -> bin
        {:error, _} -> Mix.raise(~s[Can't read #{file}])
      end

    case split_with_self(file_content, anchor) do
      [left, _middle, right] ->
        info_log("* replacing ", Path.relative_to_cwd(file_path))

        File.write!(file, [left, content, right])

      :error ->
        if raise_exception do
          Mix.raise(~s[Could not find #{anchor} in #{file_path}])
        else
          :error
        end
    end
  end

  def replace_content_all(file_path, anchor, content) do
    case replace_content(file_path, anchor, content, false) do
      :ok ->
        replace_content_all(file_path, anchor, content)

      :error ->
        nil
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
        info_log("* injecting ", Path.relative_to_cwd(file_path))

        File.write!(file, [left, middle, content, right])

      :error ->
        Mix.raise(~s[Could not find #{anchor} in #{file_path}])
    end
  end

  @spec prepend_content(String.t(), String.t()) :: :ok | {:error, :failed_to_read_file}
  def prepend_content(file_path, content) do
    case File.read(file_path) do
      {:ok, file_content} ->
        info_log("* prepending ", Path.relative_to_cwd(file_path))
        File.write!(file_path, [content, file_content])

      {:error, _} ->
        error_log("Can't read #{file_path}")

        {:error, :failed_to_read_file}
    end
  end

  @spec prepend_content!(String.t(), String.t()) :: :ok
  def prepend_content!(file_path, content) do
    case File.read(file_path) do
      {:ok, file_content} ->
        info_log("* prepending ", Path.relative_to_cwd(file_path))
        File.write!(file_path, [content, file_content])

      {:error, _} ->
        Mix.raise(~s[Can't read #{file_path}])
    end
  end

  def append_content(file_path, content) do
    file = Path.join([file_path])

    file_content =
      case File.read(file) do
        {:ok, bin} -> bin
        {:error, _} -> Mix.raise(~s[Can't read #{file}])
      end

    info_log("* appending ", Path.relative_to_cwd(file_path))
    File.write!(file, [file_content, content])
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

  def make_directory(path, touch_directory \\ true) do
    case File.mkdir_p(path) do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.raise(~s[Failed to make directory #{path} reason: #{Atom.to_string(reason)}])
    end

    create_keep_file(path, touch_directory)
  end

  def create_file(path, content) do
    case File.write(path, content) do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.raise(~s[Failed to create file at #{path}, reason: #{Atom.to_string(reason)}])
    end
  end

  def info_log(prefix, content \\ ""), do: Mix.shell().info([:green, prefix, :reset, content])

  def error_log(content \\ ""), do: Mix.shell().error(content)

  defp split_with_self(contents, text) do
    case :binary.split(contents, text) do
      [left, right] -> [left, text, right]
      [_] -> :error
    end
  end

  defp create_keep_file(path, true) do
    case File.touch("#{path}/.keep") do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.raise(~s[Failed to create .keep file at #{path}, reason: #{Atom.to_string(reason)}])
    end
  end

  defp create_keep_file(_path, _touch_directory), do: :ok
end
