defmodule Nimble.Phx.Gen.Template.Project do
  defstruct otp_app: nil,
            base_module: nil,
            web_module: nil,
            web_test_path: nil,
            is_api_project: nil

  def api?(project), do: project.is_api_project === true
end
