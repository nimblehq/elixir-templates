defmodule Nimble.Phx.Gen.Template.Project do
  alias Nimble.Phx.Gen.Template.Project

  defstruct otp_app: nil,
            base_module: nil,
            web_module: nil,
            web_test_path: nil,
            is_api_project: nil

  def info(opts \\ %{}) do
    %Project{
      is_api_project: opts[:api],
      otp_app: Mix.Phoenix.otp_app(),
      base_module: Mix.Phoenix.base(),
      web_module: Mix.Phoenix.inflect("_DUMMY_")[:web_module],
      web_test_path: Mix.Phoenix.web_test_path(Mix.Phoenix.otp_app())
    }
  end

  def api?(project), do: project.is_api_project === true
end
