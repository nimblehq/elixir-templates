defmodule NimbleTemplate.Addons.Phoenix.HealthPlugTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    @describetag required_addons: [:ExCoveralls, :"Phoenix.MixRelease"]

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

    test "adds forward health path in router", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.HealthPlug.apply!(project)

        assert_file("lib/nimble_template_web/router.ex", fn file ->
          assert file =~ """
                   forward Application.compile_env(:nimble_template, NimbleTemplateWeb.Endpoint)[:health_path], NimbleTemplateWeb.HealthPlug
                 """
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
