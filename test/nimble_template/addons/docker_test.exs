defmodule NimbleTemplate.Addons.DockerTest do
  use NimbleTemplate.AddonCase, async: false

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
          assert file =~ """
                 ARG ELIXIR_IMAGE_VERSION=1.12.2
                 ARG ERLANG_IMAGE_VERSION=24.0.4
                 ARG RELEASE_IMAGE_VERSION=3.14.0

                 FROM hexpm/elixir:${ELIXIR_IMAGE_VERSION}-erlang-${ERLANG_IMAGE_VERSION}-alpine-${RELEASE_IMAGE_VERSION} AS build
                 """

          assert file =~ "FROM alpine:${RELEASE_IMAGE_VERSION} AS app"

          assert file =~ """
                 RUN cd assets && \\
                 \t\tnpm ci --progress=false --no-audit --loglevel=error && \\
                 \t\tnpm run deploy && \\
                 \t\tcd - && \\
                 \t\tmix phx.digest
                 """

          assert file =~ "adduser -u 1000 -G appuser -g appuser -s /bin/sh -D appuser"
          assert file =~ "USER app_user"

          assert file =~
                   "COPY --from=build --chown=1000:1000 /app/_build/prod/rel/nimble_template ./"
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
          refute file =~ """
                 RUN cd assets && \\
                 \t\tnpm ci --progress=false --no-audit --loglevel=error && \\
                 \t\tnpm run deploy && \\
                 \t\tcd - && \\
                 \t\tmix phx.digest
                 """
        end)
      end)
    end
  end
end
