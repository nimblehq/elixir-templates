defmodule NimbleTemplate.Version do
  @moduledoc false

  alias NimbleTemplate.Generator
  alias NimbleTemplate.Projects.Project

  def bump(new_version) do
    current_version = Mix.Project.config()[:version]

    if new_version > current_version do
      bump_version_to(current_version, new_version)

      :ok
    else
      Mix.raise("The new version must be greater than #{current_version}")
    end
  end

  def upgrade_stack(elixir_erlang_node_alpine_versions) do
    elixir_version = Map.get(elixir_erlang_node_alpine_versions, :elixir_version, nil)
    erlang_version = Map.get(elixir_erlang_node_alpine_versions, :erlang_version, nil)
    node_version = Map.get(elixir_erlang_node_alpine_versions, :node_version, nil)
    alpine_version = Map.get(elixir_erlang_node_alpine_versions, :alpine_version, nil)

    if elixir_version do
      upgrade_elixir(elixir_version)
    end

    if erlang_version do
      upgrade_erlang(erlang_version)
    end

    if alpine_version do
      upgrade_alpine(alpine_version)
    end

    if node_version do
      upgrade_node(node_version)
    end

    :ok
  end

  defp bump_version_to(current_version, new_version) do
    Generator.replace_content(
      "mix.exs",
      "version: \"#{current_version}\",",
      "version: \"#{new_version}\","
    )

    Generator.replace_content(
      "README.md",
      "{:nimble_template, \"~> #{current_version}\", only: :dev, runtime: false},",
      "{:nimble_template, \"~> #{new_version}\", only: :dev, runtime: false},"
    )
  end

  defp upgrade_elixir(new_version) do
    current_version = Project.elixir_version()

    Generator.replace_content(
      "lib/nimble_template/projects/project.ex",
      "@elixir_version \"#{current_version}\"",
      "@elixir_version \"#{new_version}\""
    )

    Generator.replace_content(
      ".tool-versions",
      "elixir #{current_version}",
      "elixir #{new_version}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/asdf_tool_version_test.exs",
      "elixir #{current_version}-otp-#{}",
      "elixir #{new_version}-otp-#{}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/github_test.exs",
      "Elixir #{current_version}",
      "Elixir #{new_version}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/readme_test.exs",
      "Elixir #{current_version}",
      "Elixir #{new_version}"
    )

    Generator.replace_content(
      "test/nimble_template/addons/variants/docker_test.exs",
      "ELIXIR_IMAGE_VERSION=#{current_version}",
      "ELIXIR_IMAGE_VERSION=#{new_version}"
    )
  end

  defp upgrade_erlang(new_version) do
    current_version = Project.erlang_version()

    Generator.replace_content(
      "lib/nimble_template/projects/project.ex",
      "@erlang_version \"#{current_version}\"",
      "@erlang_version \"#{new_version}\""
    )

    Generator.replace_content(
      ".tool-versions",
      "erlang #{current_version}",
      "erlang #{new_version}"
    )

    Generator.replace_content(
      ".tool-versions",
      "-otp-#{Project.get_otp_major_version(current_version)}",
      "-otp-#{Project.get_otp_major_version(new_version)}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/asdf_tool_version_test.exs",
      "erlang #{current_version}",
      "erlang #{new_version}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/asdf_tool_version_test.exs",
      "-otp-#{Project.get_otp_major_version(current_version)}",
      "-otp-#{Project.get_otp_major_version(new_version)}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/github_test.exs",
      "Erlang #{current_version}",
      "Erlang #{new_version}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/readme_test.exs",
      "Erlang #{current_version}",
      "Erlang #{new_version}"
    )

    Generator.replace_content(
      "test/nimble_template/addons/variants/docker_test.exs",
      "ERLANG_IMAGE_VERSION=#{current_version}",
      "ERLANG_IMAGE_VERSION=#{new_version}"
    )
  end

  defp upgrade_alpine(new_version) do
    current_version = Project.alpine_version()

    Generator.replace_content(
      "lib/nimble_template/projects/project.ex",
      "@alpine_version \"#{current_version}\"",
      "@alpine_version \"#{new_version}\""
    )

    Generator.replace_content(
      "test/nimble_template/addons/variants/docker_test.exs",
      "RELEASE_IMAGE_VERSION=#{current_version}",
      "RELEASE_IMAGE_VERSION=#{new_version}"
    )
  end

  defp upgrade_node(new_version) do
    current_version = Project.node_asdf_version()

    Generator.replace_content(
      "lib/nimble_template/projects/project.ex",
      "@node_asdf_version \"#{current_version}\"",
      "@node_asdf_version \"#{new_version}\""
    )

    Generator.replace_content(
      ".tool-versions",
      "nodejs #{current_version}",
      "nodejs #{new_version}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/asdf_tool_version_test.exs",
      "nodejs #{current_version}",
      "nodejs #{new_version}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/github_test.exs",
      "Node #{current_version}",
      "Node #{new_version}"
    )

    Generator.replace_content_all(
      "test/nimble_template/addons/readme_test.exs",
      "Node #{current_version}",
      "Node #{new_version}"
    )
  end
end
