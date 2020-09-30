defmodule Nimble.Phx.Gen.Template.ProjectTest do
  use ExUnit.Case, async: true

  alias Nimble.Phx.Gen.Template.Project

  test "#api?" do
    assert Project.api?(%Project{is_api_project: true}) === true
    assert Project.api?(%Project{is_api_project: false}) === false
  end
end
