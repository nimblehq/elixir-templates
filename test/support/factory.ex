defmodule Nimble.Factory do
  use ExMachina.Ecto, repo: Nimble.Repo

  # Define your factories
  # def user_factory do
  #   %User{
  #     email: sequence(:email, &"test-#{&1}@omise.co")
  #   }
  # end
end
