defmodule NimbleTemplate.Addons.Phoenix.Web.CoreComponents do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply!(%Project{web_path: web_path} = project, _opts) do
    Generator.replace_content_all(
      "#{web_path}/components/core_components.ex",
      "Phoenix.HTML.Form.",
      "Form."
    )

    Generator.replace_content!(
      "#{web_path}/components/core_components.ex",
      """
        alias Phoenix.LiveView.JS
        import SampleProjectWeb.Gettext
      """,
      """
        import SampleProjectWeb.Gettext

        alias Phoenix.HTML.Form
        alias Phoenix.LiveView.JS
      """
    )

    project
  end
end
