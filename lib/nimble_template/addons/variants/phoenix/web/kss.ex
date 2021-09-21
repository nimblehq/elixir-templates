defmodule NimbleTemplate.Addons.Phoenix.Web.Kss do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_files()
    |> copy_files()
  end

  defp edit_files(%Project{} = project) do
    project
    |> edit_package_json()
    |> edit_endpoint()
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, ".kss-config.json", "assets/.kss-config.json"}])

    project
  end

  defp edit_package_json(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "kss": "^3.0.1",
      """
    )

    Generator.replace_content(
      "assets/package.json",
      """
        "scripts": {
      """,
      """
        "scripts": {
          "styleguide.generate": "kss --config .kss-config.json",
      """
    )

    project
  end

  def edit_endpoint(%Project{otp_app: otp_app} = project) do
    Generator.replace_content(
      "lib/#{otp_app}_web/endpoint.ex",
      """
        only: ~w(css fonts images js favicon.ico robots.txt)
      """,
      """
        only: ~w(css fonts images styleguide js favicon.ico robots.txt)
      """
    )

    project
  end
end
