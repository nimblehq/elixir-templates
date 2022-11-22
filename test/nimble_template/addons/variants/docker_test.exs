defmodule NimbleTemplate.Addons.Phoenix.DockerTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply!/2" do
    test "copies the docker-compose.dev.yml", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.Docker.apply!(project)

        assert_file("docker-compose.dev.yml", fn file ->
          assert file =~ """
                 version: "3.8"

                 services:
                   db:
                     image: postgres:14.2
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
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.Docker.apply!(project)

        assert_file("docker-compose.yml")
      end)
    end

    test "copies the .dockerignore", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.Docker.apply!(project)

        assert_file(".dockerignore")
      end)
    end

    test "copies the Dockerfile", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.Docker.apply!(project)

        assert_file("Dockerfile", fn file ->
          assert file =~ """
                 ARG ELIXIR_IMAGE_VERSION=1.14.0
                 ARG ERLANG_IMAGE_VERSION=25.0.4
                 ARG RELEASE_IMAGE_VERSION=3.14.6

                 FROM hexpm/elixir:${ELIXIR_IMAGE_VERSION}-erlang-${ERLANG_IMAGE_VERSION}-alpine-${RELEASE_IMAGE_VERSION} AS build
                 """

          assert file =~ "FROM alpine:${RELEASE_IMAGE_VERSION} AS app"

          assert file =~ """
                 RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
                 RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk
                 RUN apk add glibc-2.34-r0.apk
                 """

          assert file =~ """
                 RUN cd assets && \\
                 \t\tnpm ci --progress=false --no-audit --loglevel=error

                 ENV NODE_ENV=production

                 RUN mix assets.deploy
                 """

          assert file =~ "adduser -u 1000 -G appuser -g appuser -s /bin/sh -D appuser"
          assert file =~ "USER appuser"

          assert file =~
                   "COPY --from=build --chown=1000:1000 /app/_build/prod/rel/nimble_template ./"
        end)
      end)
    end

    test "copies the bin/start.sh", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project!(test_project_path, fn ->
        PhoenixAddons.Docker.apply!(project)

        assert_file("bin/start.sh", fn file ->
          assert file =~ """
                 bin/nimble_template eval "NimbleTemplate.ReleaseTasks.migrate()"

                 bin/nimble_template start
                 """
        end)
      end)
    end
  end

  describe "#apply!/2 with api_project" do
    test "copies the Dockerfile", %{
      project: project,
      test_project_path: test_project_path
    } do
      project = %{project | api_project?: true, web_project?: false}

      in_test_project!(test_project_path, fn ->
        PhoenixAddons.Docker.apply!(project)

        assert_file("Dockerfile", fn file ->
          refute file =~ """
                 RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
                 RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk
                 RUN apk add glibc-2.34-r0.apk
                 """

          refute file =~ """
                 RUN cd assets && \\
                 \t\tnpm ci --progress=false --no-audit --loglevel=error

                 ENV NODE_ENV=production

                 RUN mix assets.deploy
                 """
        end)
      end)
    end
  end
end
