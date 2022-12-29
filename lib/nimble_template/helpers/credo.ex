defmodule NimbleTemplate.CredoHelper do
  alias NimbleTemplate.Generator
  alias NimbleTemplate.Projects.Project

  @do_single_expression_rule_name "CompassCredoPlugin.Check.DoSingleExpression"
  @single_module_file_rule_name "CompassCredoPlugin.Check.SingleModuleFile"

  def suppress_credo_warnings_for_base_project(%Project{base_module: base_module}) do
    base_module_path = "lib/#{Macro.underscore(base_module)}.ex"

    disable_rule(base_module_path, @do_single_expression_rule_name)
  end

  def suppress_credo_warnings_for_phoenix_project(project) do
    suppress_credo_warnings_for_base_project(project)

    project
    |> get_files_containing_single_expression()
    |> disable_rules(@do_single_expression_rule_name)
  end

  def suppress_credo_warnings_for_phoenix_api_project(project) do
    suppress_credo_warnings_for_base_project(project)

    project
    |> get_files_containing_multiple_modules()
    |> disable_rules(@single_module_file_rule_name)

    project
    |> get_files_containing_single_expression()
    |> disable_rules(@do_single_expression_rule_name)
  end

  defp get_files_containing_single_expression(%Project{
         base_path: base_path,
         web_path: web_path
       }) do
    [
      "#{base_path}/release_tasks.ex",
      "#{web_path}/controllers/page_controller.ex",
      "#{web_path}/telemetry.ex",
      "#{web_path}/views/error_view.ex"
    ]
  end

  defp get_files_containing_multiple_modules(%Project{
         web_test_path: web_test_path
       }) do
    [
      "#{web_test_path}/views/api/error_view_test.exs",
      "#{web_test_path}/params/params_validator_test.exs"
    ]
  end

  defp disable_rules(file_paths, rule_name) do
    Enum.each(file_paths, fn file_path ->
      disable_rule(file_path, rule_name)
    end)
  end

  defp disable_rule(file_path, rule) do
    if File.exists?(file_path) do
      Generator.prepend_content(file_path, """
      # credo:disable-for-this-file #{rule}
      """)
    end
  end
end
