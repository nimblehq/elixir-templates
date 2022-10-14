defmodule NimbleTemplate.Projects.Project do
  @moduledoc false

  @alpine_version "3.14.6"
  @elixir_version "1.14.0"
  @erlang_version "25.0.4"
  @node_asdf_version "16.15.0"

  defstruct base_module: nil,
            base_path: nil,
            base_test_path: nil,
            otp_app: nil,
            web_module: nil,
            web_path: nil,
            web_test_path: nil,
            # Dependency Versions
            alpine_version: @alpine_version,
            elixir_version: @elixir_version,
            erlang_version: @erlang_version,
            node_asdf_version: @node_asdf_version,
            elixir_asdf_version: nil,
            # Variants
            api_project?: false,
            live_project?: false,
            web_project?: false,
            mix_project?: false,
            installed_addons: []

  @type t :: %__MODULE__{
          base_module: String.t() | nil,
          base_path: String.t() | nil,
          base_test_path: String.t() | nil,
          otp_app: String.t() | nil,
          web_module: String.t() | nil,
          web_path: String.t() | nil,
          web_test_path: String.t() | nil,
          alpine_version: String.t(),
          elixir_version: String.t(),
          erlang_version: String.t(),
          node_asdf_version: String.t(),
          elixir_asdf_version: String.t() | nil,
          api_project?: boolean(),
          live_project?: boolean(),
          web_project?: boolean(),
          mix_project?: boolean(),
          installed_addons: list(atom())
        }

  @spec new(map()) :: __MODULE__.t()
  def new(opts \\ %{}) do
    %__MODULE__{
      otp_app: otp_app(),
      api_project?: api_project?(opts),
      web_project?: web_project?(opts),
      live_project?: live_project?(opts),
      mix_project?: mix_project?(opts),
      elixir_asdf_version: "#{@elixir_version}-otp-#{get_otp_major_version(@erlang_version)}",
      installed_addons: []
    }
    |> init_base_module_fields()
    |> maybe_init_web_fields()
  end

  @spec alpine_version :: String.t()
  def alpine_version, do: @alpine_version

  @spec elixir_version :: String.t()
  def elixir_version, do: @elixir_version

  @spec erlang_version :: String.t()
  def erlang_version, do: @erlang_version

  @spec node_asdf_version :: String.t()
  def node_asdf_version, do: @node_asdf_version

  @spec get_otp_major_version(String.t()) :: String.t()
  def get_otp_major_version(erlang_version) do
    erlang_version
    |> String.split(".")
    |> List.first()
  end

  defp api_project?(opts), do: opts[:api] === true

  defp web_project?(opts), do: opts[:web] === true || opts[:live] === true

  defp live_project?(opts), do: opts[:live] === true

  defp mix_project?(opts), do: opts[:mix] === true

  defp otp_app(), do: Mix.Phoenix.otp_app()

  defp init_base_module_fields(
         %{
           mix_project?: true
         } = project
       ) do
    Map.merge(project, %{base_module: base_module(project)})
  end

  defp init_base_module_fields(project) do
    base_module_path =
      otp_app()
      |> Atom.to_string()
      |> Macro.underscore()

    Map.merge(project, %{
      base_module: base_module(project),
      base_path: "lib/" <> base_module_path,
      base_test_path: "test/" <> base_module_path
    })
  end

  defp maybe_init_web_fields(
         %{
           base_module: base_module,
           base_path: "lib/" <> base_path,
           api_project?: api_project?,
           live_project?: live_project?,
           web_project?: web_project?
         } = project
       )
       when true in [api_project?, live_project?, web_project?] do
    Map.merge(project, %{
      web_module: base_module <> "Web",
      web_path: "lib/" <> base_path <> "_web",
      web_test_path: "test/" <> base_path <> "_web"
    })
  end

  defp maybe_init_web_fields(project), do: project

  defp base_module(%{mix_project?: true}) do
    mix_file_content = File.read!("mix.exs")

    ~r/defmodule (.*) do/
    |> Regex.run(mix_file_content)
    |> List.last()
    |> String.split(".")
    |> List.first()
  end

  defp base_module(_project), do: Mix.Phoenix.base()
end
