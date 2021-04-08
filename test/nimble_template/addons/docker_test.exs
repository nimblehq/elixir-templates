defmodule NimbleTemplate.Addons.DockerTest do
  use NimbleTemplate.AddonCase

  describe "#apply/2" do
    test "copies the docker-compose.dev.yml", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Docker.apply(project)

        assert_file("docker-compose.dev.yml", fn file ->
          assert file =~ """
                 version: "3.8"

                 services:
                   db:
                     image: postgres:12.3
                     container_name: nimble_template_db
                     environment:
                       - POSTGRES_HOST_AUTH_METHOD=trust
                       - POSTGRES_DB=nimble_template_dev
                     ports:
                       - "5432:5432"
                 """
        end)
      end)
    end

    test "copies the docker-compose.yml", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Docker.apply(project)

        assert_file("docker-compose.yml")
      end)
    end

    test "copies the .dockerignore", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Docker.apply(project)

        assert_file(".dockerignore")
      end)
    end

    test "copies the Dockerfile", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Docker.apply(project)

        assert_file("Dockerfile", fn file ->
          assert file =~ "FROM hexpm/elixir:1.11.4-erlang-23.3-alpine-3.13.2 AS build"
          assert file =~ "FROM alpine:3.13.2 AS app"

          assert file =~
                   "RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error"

          assert file =~ "adduser -s /bin/sh -G app_group -D app_user &&"
          assert file =~ "USER app_user"

          assert file =~
                   "COPY --from=build --chown=app_user:app_group /app/_build/prod/rel/nimble_template ./"
        end)
      end)
    end

    test "copies the bin/start.sh", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Docker.apply(project)

        assert_file("bin/start.sh", fn file ->
          assert file =~ """
                 bin/nimble_template eval "NimbleTemplate.ReleaseTasks.migrate()"

                 bin/nimble_template start
                 """
        end)
      end)
    end
  end

  describe "#apply/2 with api_project" do
    test "copies the Dockerfile", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project(test_project_path, fn ->
        Addons.Docker.apply(project)

        assert_file("Dockerfile", fn file ->
          refute file =~
                   "RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error"
        end)
      end)
    end
  end
end
