defmodule NimbleTemplate.Generator do
  @moduledoc false

  @template_resource "priv/templates/nimble_template"

  def copy_directory!(source_path, target_path, binding \\ []) do
    root = Application.app_dir(:nimble_template, @template_resource)

    "#{root}/#{source_path}/**/*"
    |> Path.wildcard(match_dot: true)
    |> Enum.reject(&File.dir?/1)
    |> Enum.map(&String.replace(&1, "#{root}/", ""))
    |> Enum.each(&copy_file!([{:text, &1, String.replace(&1, source_path, target_path)}], binding))
  end

  def copy_file!(files, binding \\ []) do
    Mix.Phoenix.copy_from(
      [:nimble_template],
      @template_resource,
      binding,
      files
    )
  end

  def rename_file!(old_path, new_path), do: File.rename!(old_path, new_path)

  def replace_content!(file_path, anchor, content) do
    case replace_content(file_path, anchor, content) do
      :ok ->
        :ok

      {:error, error_message} ->
        Mix.raise(error_message)
    end
  end

  def replace_content(_file_path, anchor, content) when anchor == content, do: :ok

  def replace_content(file_path, anchor, content) do
    file = Path.join([file_path])

    with {:ok, file_content} <- read_file(file),
         :ok <- do_replace_content(file, file_path, file_content, content, anchor) do
      :ok
    else
      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def replace_content_all(_file_path, anchor, content) when anchor == content, do: :ok

  def replace_content_all(file_path, anchor, content) do
    case replace_content(file_path, anchor, content) do
      :ok ->
        replace_content_all(file_path, anchor, content)

      {:error, _} ->
        nil
    end
  end

  def delete_content!(file_path, anchor), do: replace_content!(file_path, anchor, "")

  def inject_content!(file_path, anchor, content) do
    file = Path.join([file_path])

    {:ok, file_content} = read_file!(file)

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

  def append_content!(file_path, content) do
    file = Path.join([file_path])

    {:ok, file_content} = read_file!(file)

    info_log("* appending ", Path.relative_to_cwd(file_path))
    File.write!(file, [file_content, content])
  end

  def inject_mix_dependency!(dependencies) when is_list(dependencies) do
    inject_content!(
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

  def inject_mix_dependency!(dependency) do
    inject_content!(
      "mix.exs",
      """
        defp deps do
          [
      """,
      "      " <> inspect(dependency) <> ",\n"
    )
  end

  def make_directory!(path, touch_directory \\ true) do
    case File.mkdir_p(path) do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.raise(~s[Failed to make directory #{path} reason: #{Atom.to_string(reason)}])
    end

    create_keep_file!(path, touch_directory)
  end

  def create_file!(path, content) do
    case File.write(path, content) do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.raise(~s[Failed to create file at #{path}, reason: #{Atom.to_string(reason)}])
    end
  end

  def info_log(prefix, content \\ ""), do: Mix.shell().info([:green, prefix, :reset, content])

  def error_log(content \\ ""), do: Mix.shell().error(content)

  defp create_keep_file!(path, true) do
    case File.touch("#{path}/.keep") do
      :ok ->
        :ok

      {:error, reason} ->
        Mix.raise(~s[Failed to create .keep file at #{path}, reason: #{Atom.to_string(reason)}])
    end
  end

  defp create_keep_file!(_path, _touch_directory), do: :ok

  defp read_file(file) do
    case File.read(file) do
      {:ok, file_content} ->
        {:ok, file_content}

      {:error, _} ->
        {:error, ~s[Can't read #{file}]}
    end
  end

  defp read_file!(file) do
    case read_file(file) do
      {:ok, file_content} ->
        {:ok, file_content}

      {:error, error_message} ->
        Mix.raise(error_message)
    end
  end

  defp do_replace_content(file, file_path, file_content, content, anchor) do
    case split_with_self(file_content, anchor) do
      [left, _middle, right] ->
        info_log("* replacing ", Path.relative_to_cwd(file_path))

        case File.write(file, [left, content, right]) do
          :ok ->
            :ok

          {:error, _} ->
            {:error, ~s[Could not replace content in #{file_path}]}
        end

      :error ->
        {:error, ~s[Could not find #{anchor} in #{file_path}]}
    end
  end

  defp split_with_self(contents, text) do
    case :binary.split(contents, text) do
      [left, right] -> [left, text, right]
      [_] -> :error
    end
  end
end
