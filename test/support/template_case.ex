defmodule NimbleTemplate.TemplateCase do
  use ExUnit.CaseTemplate

  alias NimbleTemplate.Test.FileHelper

  using do
    quote do
      import NimbleTemplate.Test.FileHelper
    end
  end

  setup do
    test_project_path = FileHelper.parent_test_project_path()

    File.mkdir_p!(test_project_path)

    Mix.shell().cmd("cp ./* .tool-versions #{test_project_path} 2> /dev/null")
    Mix.shell().cmd("cp -r ./lib ./test #{test_project_path} 2> /dev/null")

    on_exit(fn ->
      File.rm_rf!(test_project_path)
    end)

    {:ok, test_project_path: test_project_path}
  end
end
