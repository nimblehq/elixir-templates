# NimblePhxGenTemplate

Project repository template to set up all public Phoenix projects at [Nimble](https://nimblehq.co/)

## Installation

```elixir
def deps do
  [
    {:nimble_phx_gen_template, git: "https://github.com/nimblehq/elixir-templates", branch: "master"}
  ]
end
```

Then run `mix deps.get` to install NimblePhxGenTemplate

## Usage

```
mix nimble.phx.gen.template -v # Print the version
mix nimble.phx.gen.template --web # Apply the Web template to a Phoenix project
mix nimble.phx.gen.template --api # Apply the API template to a Phoenix project
```

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
