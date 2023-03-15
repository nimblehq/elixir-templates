defmodule NimbleTemplate.Addons.Credo do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{} = project, _opts) do
    project
    |> copy_files!()
    |> edit_files!()
  end

  defp copy_files!(%Project{mix_project?: true} = project) do
    Generator.copy_file!([{:text, ".credo.mix.exs", ".credo.exs"}])

    project
  end

  defp copy_files!(
         %Project{web_path: web_path, base_path: base_path, mix_project?: false} = project
       ) do
    binding = [
      base_entry_path: "#{base_path}.ex",
      web_entry_path: "#{web_path}.ex"
    ]

    Generator.copy_file!([{:eex, ".credo.exs", ".credo.exs"}], binding)

    project
  end

  defp edit_files!(%Project{} = project) do
    project
    |> inject_mix_dependency!()
    |> edit_mix!()
    |> edit_web_entry!()
  end

  defp inject_mix_dependency!(project) do
    Generator.inject_mix_dependency!([
      {:credo, latest_package_version(:credo), only: [:dev, :test], runtime: false},
      {:compass_credo_plugin, latest_package_version(:compass_credo_plugin),
       only: [:dev, :test], runtime: false}
    ])

    project
  end

  defp edit_mix!(project) do
    Generator.replace_content!(
      "mix.exs",
      """
            codebase: [
      """,
      """
            codebase: [
              "credo --strict",
      """
    )

    project
  end

  defp edit_web_entry!(
         %Project{web_path: web_path, web_module: web_module, web_project?: true} = project
       ) do
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

  defp edit_web_entry!(project) do
    project
  end
end
