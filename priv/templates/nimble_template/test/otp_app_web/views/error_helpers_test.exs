defmodule <%= web_module %>.ErrorHelpersTest do
  use <%= web_module %>.ViewCase, async: true

  alias <%= web_module %>.ErrorHelpers

  describe "status_code_from_template/1" do
    test "given 404.json, returns :not_found error code" do
      assert ErrorHelpers.status_code_from_template("404.json") == :not_found
    end

    test "given 500.json, returns :internal_server_error error code" do
      assert ErrorHelpers.status_code_from_template("500.json") == :internal_server_error
    end

    test "given non-existing error number, returns :internal_server_error error code" do
      assert ErrorHelpers.status_code_from_template("99999.json") == :internal_server_error
    end
  end
end
