defmodule Nimble.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import Nimble.Factory
      import Nimble.Gettext

      alias Nimble.Router.Helpers, as: Routes
    end
  end
end
