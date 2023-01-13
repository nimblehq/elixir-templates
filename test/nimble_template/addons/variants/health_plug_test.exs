defmodule NimbleTemplate.Addons.Phoenix.HealthPlugTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    @describetag required_addons: [:ExCoveralls, :"Phoenix.MixRelease"]
    @describetag mock_latest_package_versions: [{:excoveralls, "0.12.2"}]

    test "copies the health plug file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("lib/nimble_template_web/plugs/health_plug.ex")
      end)
    end

    test "copies the health plug test files", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("test/nimble_template_web/plugs/health_plug_test.exs")
        assert_file("test/nimble_template_web/requests/_health/liveness_request_test.exs")
        assert_file("test/nimble_template_web/requests/_health/readiness_request_test.exs")
      end)
    end

    test "adds health path configuration in config", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("config/config.exs", fn file ->
          assert file =~ """
                 config :nimble_template, NimbleTemplateWeb.Endpoint,
                   health_path: "/_health",
                 """
        end)

        assert_file("config/runtime.exs", fn file ->
          assert file =~ """
                   config :nimble_template, NimbleTemplateWeb.Endpoint,
                     health_path: System.fetch_env!("HEALTH_PATH"),
                 """
        end)
      end)
    end

    test "creates the `router_helper.ex` file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("lib/nimble_template_web/helpers/router_helper.ex", fn file ->
          assert file =~ """
                 defmodule NimbleTemplateWeb.RouterHelper do
                   def health_path, do: Application.get_env(:nimble_template, NimbleTemplateWeb.Endpoint)[:health_path]
                 end
                 """
        end)
      end)
    end

    test "creates the `router_helper_test.exs` file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("test/nimble_template_web/helpers/router_helper_test.exs", fn file ->
          assert file =~ """
                 defmodule NimbleTemplateWeb.RouterHelperTest do
                   use NimbleTemplateWeb.ConnCase, async: true

                   alias NimbleTemplateWeb.RouterHelper

                   describe "health_path/0" do
                     test "returns the `health_path` from the Application configuration" do
                       assert RouterHelper.health_path() == "/_health"
                     end
                   end
                 end
                 """
        end)
      end)
    end

    test "adds forward health path in router", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("lib/nimble_template_web/router.ex", fn file ->
          assert file =~ "alias NimbleTemplateWeb.RouterHelper"
          assert file =~ "forward RouterHelper.health_path(), NimbleTemplateWeb.HealthPlug"
        end)
      end)
    end

    test "adds `Mimic.copy(Ecto.Adapters.SQL)` to test_helper", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("test/test_helper.exs", fn file ->
          assert file =~ "Mimic.copy(Ecto.Adapters.SQL)"
        end)
      end)
    end
  end
end
