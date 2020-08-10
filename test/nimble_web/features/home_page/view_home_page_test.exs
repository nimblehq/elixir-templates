defmodule NimbleWeb.HomePage.ViewHomePageTest do
  use NimbleWeb.FeatureCase

  feature "view home page", %{session: session} do
    session
    |> visit(Routes.page_path(NimbleWeb.Endpoint, :index))

    session
    |> assert_has(Query.text("Welcome to Phoenix!"))
  end
end
