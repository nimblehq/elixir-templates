defmodule Nimble.Phx.Gen.Template.Addons.ExVCRTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    @describetag mock_latest_package_versions: [{:exvcr, "0.12.2"}]

    test "injects ExVCR to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExVCR.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ "{:exvcr, \"~> 0.12.2\", [only: :test]}"
        end)
      end)
    end

    test "updates configurations for test env", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExVCR.apply(project)

        assert_file("config/test.exs", fn file ->
          assert file =~ """
                 # Configurations for ExVCR
                 config :exvcr,
                   vcr_cassette_library_dir: "test/support/fixtures/vcr_cassettes"
                 """
        end)
      end)
    end

    test "updates test cases", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.ExVCR.apply(project)

        assert_file("test/support/data_case.ex", fn file ->
          assert file =~ "use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney"
        end)

        assert_file("test/support/conn_case.ex", fn file ->
          assert file =~ "use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney"
        end)
      end)
    end

    test "creates cassettes directory with .keep file", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.ExVCR.apply(project)

        assert(File.exists?("test/support/fixtures/vcr_cassettes/.keep")) == true
      end)
    end
  end
end
