defmodule <%= web_module %>.Api.ErrorViewTest do
  use <%= web_module %>.ViewCase, async: true

  alias <%= web_module %>.Api.ErrorView

  defmodule Device do
    use Ecto.Schema

    import Ecto.Changeset

    schema "devices" do
      field :device_id, :string
      field :operating_system, :string
      field :device_name, :string

      timestamps()
    end

    def changeset(device \\ %__MODULE__{}, attrs) do
      device
      |> cast(attrs, [
        :device_id,
        :operating_system,
        :device_name
      ])
      |> validate_required([
        :device_id,
        :operating_system,
        :device_name
      ])
    end
  end

  test "renders 404.json" do
    assert render(ErrorView, "404.json", []) == %{
             errors: [%{code: :not_found, detail: %{}, message: "Not Found"}]
           }
  end

  test "renders 500.json" do
    assert render(ErrorView, "500.json", []) == %{
             errors: [
               %{code: :internal_server_error, detail: %{}, message: "Internal Server Error"}
             ]
           }
  end

  test "renders custom error message" do
    assert render(ErrorView, "500.json", status: 500, message: "Something went wrong") ==
             %{
               errors: [
                 %{code: :internal_server_error, detail: %{}, message: "Something went wrong"}
               ]
             }
  end

  test "renders custom error code" do
    assert render(ErrorView, "500.json", status: 500, code: :custom_error_code) ==
             %{
               errors: [
                 %{code: :custom_error_code, detail: %{}, message: "Internal Server Error"}
               ]
             }
  end

  test "given error code and an invalid changeset with multiple errors fields, renders error.json" do
    changeset = Device.changeset(%{})
    error = %{code: :validation_error, changeset: changeset}

    assert render(ErrorView, "error.json", error) ==
             %{
               errors: [
                 %{
                   code: :validation_error,
                   detail: %{
                     device_id: ["can't be blank"],
                     device_name: ["can't be blank"],
                     operating_system: ["can't be blank"]
                   },
                   message:
                     "Device can't be blank, Device name can't be blank and Operating system can't be blank"
                 }
               ]
             }
  end

  test "given error code and an invalid changeset with single error field, renders error.json" do
    changeset = Device.changeset(%{device_id: "12345678-9012", device_name: "Android"})
    error = %{code: :validation_error, changeset: changeset}

    assert render(ErrorView, "error.json", error) ==
             %{
               errors: [
                 %{
                   code: :validation_error,
                   detail: %{operating_system: ["can't be blank"]},
                   message: "Operating system can't be blank"
                 }
               ]
             }
  end
end
