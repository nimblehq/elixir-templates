## Introduction

Phoenix/Mix template for projects at [Nimble](https://nimblehq.co/).

## Prerequisites

NimbleTemplate has been developed and actively tested with the below environment:

- Mix 1.13.3
- Elixir 1.13.3
- Erlang/OTP 24.2.2
- Phoenix 1.6.6
- Node 16.15.0

## Installation

*Note:* NimbleTemplate only works on a _new_ Phoenix/Mix project, applying it to an existing Phoenix/Mix project might not work as expected.

Step 1: Generate a new project

```bash
# New Phoenix project
mix phx.new awesome_project

# New Mix project
mix new awesome_project
```

Step 2: Add `nimble_template` dependency to `mix.exs`:

```elixir
def deps do
  [
    {:nimble_template, "~> 4.2.2", only: :dev, runtime: false},
    # other dependencies ...
  ]
end
```

Step 3: Fetch and install dependencies

Run this command in the root of the project directory to install NimbleTemplate.

```bash
mix do deps.get, deps.compile
```

## Usage

```bash
mix help nimble_template.gen # Print help

mix nimble_template.gen -v # Print the version

# Phoenix application
mix nimble_template.gen --web   # Apply the Web template
mix nimble_template.gen --api   # Apply the API template
mix nimble_template.gen --live  # Apply the LiveView template

# Non-Phoenix application
mix nimble_template.gen --mix # Apply the Mix template
```

## Running tests

The testing documentation is on [Wiki](https://github.com/nimblehq/elixir-templates/wiki)

### Release

Set the `HEX_API_KEY` as a Github secret (skip this step if it has been done).

The release process follows the [Git flow](https://nimblehq.co/compass/development/version-control/release-management).

1. Bump the new version on local

  ```bash
  mix nimble_template.bump_version new_version
  ```

2. Open a PR to develop.

3. Once that bump_version PR is merged, create the `release/<version number>` from the `develop` branch, points to the `master` branch.

4. Once the release branch is merged into the `master` branch, Github Action automatically publishes the template to [https://hex.pm/packages/nimble_template](https://hex.pm/packages/nimble_template).

## Contributing

Contributions, issues, and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/nimblehq/elixir-templates/issues).

## License

This project is Copyright (c) 2014 and onwards. It is free software, and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

![Nimble](https://assets.nimblehq.co/logo/dark/logo-dark-text-160.png)

This project is maintained and funded by Nimble.

We love open source and do our part in sharing our work with the community!
See [our other projects][community] or [hire our team][hire] to help build your product.

[community]: https://github.com/nimblehq
[hire]: https://nimblehq.co
