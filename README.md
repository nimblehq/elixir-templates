# NimblePhxGenTemplate

Project repository template to set up all public Phoenix projects at [Nimble](https://nimblehq.co/)

## Installation

```elixir
def deps do
  [
    {:nimble_phx_gen_template, git: "https://github.com/nimblehq/elixir-templates", branch: "master", only: :dev}
  ]
end
```

Then run `mix do deps.get, deps.compile` to install NimblePhxGenTemplate

## Usage

```
mix nimble.phx.gen.template -v # Print the version
mix nimble.phx.gen.template --web # Apply the Web template
mix nimble.phx.gen.template --api # Apply the API template
```
## Requirements

NimblePhxGenTemplate has been developed and actively tested with Elixir 1.11+, Erlang/OTP 23.1+ and Phoenix 1.5+. Running NimblePhxGenTemplate currently requires Elixir 1.11+, Erlang/OTP 23.1+ and Phoenix 1.5+.

## License

This project is Copyright (c) 2014-2020 Nimble. It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

![Nimble](https://assets.nimblehq.co/logo/dark/logo-dark-text-160.png)

This project is maintained and funded by Nimble.

We love open source and do our part in sharing our work with the community!
See [our other projects][community] or [hire our team][hire] to help build your product.

[community]: https://github.com/nimblehq
[hire]: https://nimblehq.co/
