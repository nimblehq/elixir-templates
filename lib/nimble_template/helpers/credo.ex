defmodule NimbleTemplate.CredoHelper do
  alias NimbleTemplate.Generator
  alias NimbleTemplate.Projects.Project

  # TODO: Move this to the Credo Addon

  @do_single_expression_rule_name "CompassCredoPlugin.Check.DoSingleExpression"
  @single_module_file_rule_name "CompassCredoPlugin.Check.SingleModuleFile"

  @spec suppress_credo_warnings_for_base_project(Project.t()) :: :ok
  def suppress_credo_warnings_for_base_project(%Project{base_module: base_module}) do
    base_module_path = "lib/#{Macro.underscore(base_module)}.ex"

    disable_rule(base_module_path, @do_single_expression_rule_name)
  end

  @spec suppress_credo_warnings_for_phoenix_project(Project.t()) :: :ok
  def suppress_credo_warnings_for_phoenix_project(project) do
    suppress_credo_warnings_for_base_project(project)

    project
    |> get_files_containing_single_expression()
    |> disable_rules(@do_single_expression_rule_name)

    disable_on_core_components(project)

    edit_web_entry(project)
  end

  @spec suppress_credo_warnings_for_phoenix_api_project(Project.t()) :: :ok
  def suppress_credo_warnings_for_phoenix_api_project(project) do
    suppress_credo_warnings_for_base_project(project)

    project
    |> get_files_containing_multiple_modules()
    |> disable_rules(@single_module_file_rule_name)

    project
    |> get_files_containing_single_expression()
    |> disable_rules(@do_single_expression_rule_name)

    disable_on_core_components(project)
  end

  defp get_files_containing_single_expression(%Project{
         base_path: base_path,
         web_path: web_path
       }) do
    [
      "#{base_path}/release_tasks.ex",
      "#{web_path}/controllers/page_controller.ex",
      "#{web_path}/telemetry.ex",
      "#{web_path}/controllers/error_json.ex",
      "#{web_path}/controllers/error_html.ex"
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

  # TODO: Could remove the core_components file as we might not need it
  defp disable_on_core_components(%Project{web_path: web_path}) do
    core_components_path = "#{web_path}/components/core_components.ex"

    if File.exists?(core_components_path) do
      Generator.prepend_content(
        core_components_path,
        """
        # credo:disable-for-this-file
        """
      )
    end
  end

  defp edit_web_entry(%Project{web_path: web_path, web_module: web_module} = project) do
    Generator.delete_content!(
      "#{web_path}.ex",
      """
        def verified_routes do
          quote do
            use Phoenix.VerifiedRoutes,
              endpoint: #{web_module}.Endpoint,
              router: #{web_module}.Router,
              statics: #{web_module}.static_paths()
          end
        end
      """
    )

    Generator.replace_content!(
      "#{web_path}.ex",
      """
        defp html_helpers do
      """,
      """
        def verified_routes do
          quote do
            use Phoenix.VerifiedRoutes,
              endpoint: #{web_module}.Endpoint,
              router: #{web_module}.Router,
              statics: #{web_module}.static_paths()
          end
        end

        defp html_helpers do
      """
    )

    project
  end
end
