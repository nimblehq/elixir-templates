defmodule NimbleTemplate.Test.FileHelper do
  import ExUnit.Assertions

  # ATTENTION: File.cd! doesn't support `async: true`, the test will fail randomly in async mode
  # https://elixirforum.com/t/randomly-getting-compilationerror-on-tests/17298/3
  def in_test_project!(test_project_path, function), do: File.cd!(test_project_path, function)

  def assert_file(path),
    do: assert(File.regular?(path), "Expected #{path} to exist, but does not")

  def assert_directory(path),
    do: assert(File.dir?(path), "Expected #{path} to exist, but does not")

  def assert_file(path, match) do
    assert_file(path)
    match.(File.read!(path))
  end

  def refute_file(path),
    do: refute(File.regular?(path), "Expected #{path} does not exist, but it does")

  def parent_test_project_path do
    project_directory =
      20
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64(padding: false)
      |> String.downcase()

    tmp_path = Path.expand("../../../tmp", __DIR__)

    Path.join(tmp_path, project_directory)
  end
end
