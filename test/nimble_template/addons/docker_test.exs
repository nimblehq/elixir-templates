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
                 ARG ELIXIR_IMAGE_VERSION=1.11.4
                 ARG ERLANG_IMAGE_VERSION=23.3
                 ARG RELEASE_IMAGE_VERSION=3.13.2

                 FROM hexpm/elixir:${ELIXIR_IMAGE_VERSION}-erlang-${ERLANG_IMAGE_VERSION}-alpine-${RELEASE_IMAGE_VERSION} AS builder
                 """

          assert file =~ "FROM alpine:${RELEASE_IMAGE_VERSION} AS app"

          assert file =~ "RUN cd assets"
          assert file =~ "npm ci --progress=false --no-audit --loglevel=error"
          assert file =~ "npm run deploy"
          assert file =~ "mix phx.digest"

          assert file =~ "adduser -u 1000 -G appuser -g appuser -s /bin/sh -D appuser"
          assert file =~ "USER app_user"

          assert file =~
                   "COPY --from=builder --chown=app_user:app_group /app/_build/prod/rel/nimble_template ./"
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
          refute file =~ "RUN cd assets"
          refute file =~ "npm ci --progress=false --no-audit --loglevel=error"
          refute file =~ "npm run deploy"
          refute file =~ "mix phx.digest"
        end)
      end)
    end
  end
end
