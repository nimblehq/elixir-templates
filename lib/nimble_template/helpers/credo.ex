defmodule NimbleTemplate.CredoHelper do
  alias NimbleTemplate.Generator
  alias NimbleTemplate.Projects.Project

  @do_single_expression_rule_name "CompassCredoPlugin.Check.DoSingleExpression"
  @single_module_file_rule_name "CompassCredoPlugin.Check.SingleModuleFile"

  @spec disable_rule(String.t(), String.t()) :: :ok | {:error, :failed_to_read_file}
  def disable_rule(file_path, rule) do
    Generator.prepend_content(file_path, """
    # credo:disable-for-this-file #{rule}
    """)
  end

  @spec disable_do_single_expression_rule(list()) :: :ok | {:error, :failed_to_read_file}
  def disable_do_single_expression_rule(file_paths) do
    Enum.each(file_paths, fn file_path ->
      disable_rule(file_path, @do_single_expression_rule_name)
    end)
  end

  @spec disable_single_module_file_rule(list()) :: :ok | {:error, :failed_to_read_file}
  def disable_single_module_file_rule(file_paths) do
    Enum.each(file_paths, fn file_path ->
      disable_rule(file_path, @single_module_file_rule_name)
    end)
  end

  def suppress_credo_warnings_for_base_project(%Project{base_module: base_module}) do
    disable_do_single_expression_rule(["lib/#{Macro.underscore(base_module)}.ex"])
  end

  def suppress_credo_warnings_for_phoenix_project(
        %Project{
          base_path: base_path,
          web_path: web_path
        } = project
      ) do
    suppress_credo_warnings_for_base_project(project)

    single_expression_files = [
      "#{web_path}/controllers/page_controller.ex",
      "#{web_path}/telemetry.ex",
      "#{web_path}/views/error_view.ex",
      "#{base_path}/release_tasks.ex"
    ]

    disable_do_single_expression_rule(single_expression_files)
  end

  def suppress_credo_warnings_for_phoenix_api_project(
        %Project{
          web_test_path: web_test_path,
          base_path: base_path,
          web_path: web_path
        } = project
      ) do
    suppress_credo_warnings_for_base_project(project)

    single_module_files = [
      "#{web_test_path}/views/api/error_view_test.exs",
      "#{web_test_path}/params/params_validator_test.exs"
    ]

    disable_single_module_file_rule(single_module_files)

    single_expression_files = [
      "#{base_path}/release_tasks.ex",
      "#{web_path}/telemetry.ex",
      "#{web_path}/views/error_view.ex"
    ]

    disable_do_single_expression_rule(single_expression_files)
  end
end
