defmodule Nimble.Phx.Gen.Template.Addons.DockerTest do
  use Nimble.Phx.Gen.Template.AddonCase

  describe "#apply/2" do
    test "copies the docker-compose.dev.yml", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Docker.apply(project, %{})

        assert_file("docker-compose.dev.yml", fn file ->
          assert file =~ """
                 version: "3.2"

                 services:
                   db:
                     image: postgres:12.3
                     container_name: nimble_phx_gen_template_db
                     environment:
                       - POSTGRES_HOST_AUTH_METHOD=trust
                       - POSTGRES_DB=nimble_phx_gen_template_dev
                     ports:
                       - "5432:5432"
                 """
        end)
      end)
    end
  end
end
