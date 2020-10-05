defmodule Nimble.Phx.Gen.Template.Project do
  alias Nimble.Phx.Gen.Template.Project

  defstruct otp_app: nil,
            base_module: nil,
            base_path: nil,
            base_test_path: nil,
            web_module: nil,
            web_path: nil,
            web_test_path: nil,
            api_project?: nil

  def info(opts \\ %{}) do
    %Project{
      api_project?: opts[:api] === true,
      otp_app: Mix.Phoenix.otp_app(),
      base_module: Mix.Phoenix.base(),
      base_path: "lib/" <> Atom.to_string(Mix.Phoenix.otp_app()),
      base_test_path: "test/" <> Atom.to_string(Mix.Phoenix.otp_app()),
      web_module: Mix.Phoenix.base() <> "Web",
      web_path: "lib/" <> Atom.to_string(Mix.Phoenix.otp_app()) <> "_web",
      web_test_path: "test/" <> Atom.to_string(Mix.Phoenix.otp_app()) <> "_web"
    }
  end
end
