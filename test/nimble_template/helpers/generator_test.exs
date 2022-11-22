defmodule NimbleTemplate.GeneratorTest do
  use NimbleTemplate.AddonCase, async: false

  alias NimbleTemplate.Generator

  describe "prepend_content/2" do
    test "prepends the given content in the given file", %{
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        File.write!("sample_module.exs", """
        defmodule SampleModule do
          def foo, do: "bar"
        end
        """)

        Generator.prepend_content("sample_module.exs", "# This is sample module\n")

        assert_file("sample_module.exs", fn file ->
          assert file == """
                 # This is sample module
                 defmodule SampleModule do
                   def foo, do: "bar"
                 end
                 """
        end)
      end)
    end

    test "when the given file does not exist, returns an error", %{
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        assert Generator.prepend_content("unknown_file.exs", "# This is sample module\n") ==
                 {:error, :failed_to_read_file}
      end)
    end
  end

  describe "prepend_content!/2" do
    test "prepends the given content in the given file", %{
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        File.write!("sample_module.exs", """
        defmodule SampleModule do
          def foo, do: "bar"
        end
        """)

        Generator.prepend_content!("sample_module.exs", "# This is sample module\n")

        assert_file("sample_module.exs", fn file ->
          assert file == """
                 # This is sample module
                 defmodule SampleModule do
                   def foo, do: "bar"
                 end
                 """
        end)
      end)
    end

    test "when the given file does not exist, raises an error", %{
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        assert_raise Mix.Error, "Can't read unknown_file.exs", fn ->
          Generator.prepend_content!("unknown_file.exs", "# This is sample module\n")
        end
      end)
    end
  end
end
