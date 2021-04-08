defmodule NimbleTemplate.AddonsWeb.WallabyTest do
  use NimbleTemplate.AddonCase

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:wallaby, "0.26.2"}]

    test "copies the test/support/feature_case.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file("test/support/feature_case.ex", fn file ->
          assert file =~ """
                 defmodule NimbleTemplateWeb.FeatureCase do
                   use ExUnit.CaseTemplate

                   using do
                     quote do
                       use Wallaby.Feature

                       import NimbleTemplate.Factory

                       alias NimbleTemplateWeb.Router.Helpers, as: Routes
                     end
                   end
                 end
                 """
        end)
      end)
    end

    test "copies the features/home_page/view_home_page_test.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file("test/nimble_template_web/features/home_page/view_home_page_test.exs")
      end)
    end

    test "injects wallaby to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:wallaby, \"~> 0.26.2\", [only: :test, runtime: false]},
                 """
        end)
      end)
    end

    test "updates test/test_helper.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ """
                 {:ok, _} = Application.ensure_all_started(:wallaby)

                 ExUnit.start()
                 Ecto.Adapters.SQL.Sandbox.mode(NimbleTemplate.Repo, :manual)

                 Application.put_env(:wallaby, :base_url, NimbleTemplateWeb.Endpoint.url())
                 """
        end)
      end)
    end

    test "updates lib/nimble_template_web/endpoint.ex", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file("lib/nimble_template_web/endpoint.ex", fn file ->
          assert file =~ """
                   use Phoenix.Endpoint, otp_app: :nimble_template

                   if Application.get_env(:nimble_template, :sql_sandbox) do
                     plug Phoenix.Ecto.SQL.Sandbox
                   end
                 """
        end)
      end)
    end

    test "updates config/test.exs", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file("config/test.exs", fn file ->
          assert file =~ """
                 config :nimble_template, NimbleTemplateWeb.Endpoint,
                   http: [port: 4002],
                   server: true

                 config :nimble_template, :sql_sandbox, true

                 config :wallaby,
                   otp_app: :nimble_template,
                   chromedriver: [headless: System.get_env("CHROME_HEADLESS", "true") === "true"],
                   screenshot_dir: "tmp/wallaby_screenshots",
                   screenshot_on_failure: true
                 """
        end)
      end)
    end

    test "updates .gitignore", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.Wallaby.apply(project)

        assert_file(".gitignore", fn file ->
          assert file =~ "**/tmp/"
        end)
      end)
    end
  end
end
