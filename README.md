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
    {:nimble_template, "~> 4.3.0", only: :dev, runtime: false},
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

### Release process

The release documentation is on [Wiki](https://github.com/nimblehq/elixir-templates/wiki)

## Contributing

Contributions, issues, and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/nimblehq/elixir-templates/issues).

## FAQ

### 1. Getting `(Mix) The task "phx.new" could not be found` error

The Phoenix application generator is missing. By solving this problem, you need to run
``` bash
mix archive.install hex phx_new
```

or

```bash
mix archive.install hex phx_new #{specific-version}
```

### 2. Getting `Wallaby can't find chromedriver` error
Your OS is missing/not installing `chromedriver`, you need to run:

Brew
``` bash
brew install --cask chromedriver
```

Apt
``` bash
apt install chromium-chromedriver
```

Or download the package on the official site:
https://chromedriver.chromium.org/downloads

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
