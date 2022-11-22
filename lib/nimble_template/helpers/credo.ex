defmodule NimbleTemplate.CredoHelper do
  alias NimbleTemplate.Generator

  @spec disable_rule(String.t(), String.t()) :: :ok | {:error, :failed_to_read_file}
  def disable_rule(file_path, rule) do
    Generator.prepend_content(file_path, """
    # credo:disable-for-this-file #{rule}
    """)
  end
end
