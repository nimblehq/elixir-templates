defmodule NimbleWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import Nimble.Factory
      import Nimble.Gettext

      alias NimbleWeb.Router.Helpers, as: Routes
    end
  end
end
