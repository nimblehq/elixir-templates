## Introduction

Phoenix template for projects at [Nimble](https://nimblehq.co/).

## Prerequisites

NimblePhxGenTemplate has been developed and actively tested with the below environment:

- Elixir 1.11.3
- Erlang/OTP 23.2.1
- Phoenix 1.5.7

## Installation

*Note:* NimblePhxGenTemplate only works on a _new_ Phoenix project, applying it to an existing Phoenix project might not work as expected.

Step 1: Generate a new Phoenix project

```bash
mix phx.new hello_elixir
```

Step 2: Add `nimble_phx_gen_template` dependency to `mix.exs`:

```elixir
def deps do
  [
    {:nimble_phx_gen_template, "~> 2.2.0", only: :dev, runtime: false},
    # other dependencies ...
  ]
end
```

Step 3: Fetch and install dependencies

Run this command in the root of project directory to install NimblePhxGenTemplate.

```bash
mix do deps.get, deps.compile
```

Step 4: Run migrate

```bash
mix ecto.migrate
```

## Usage

```
mix nimble.phx.gen.template -v      # Print the version
mix nimble.phx.gen.template --web   # Apply the Web template
mix nimble.phx.gen.template --api   # Apply the API template
mix nimble.phx.gen.template --live  # Apply the LiveView template
```

## Running tests

NimblePhxGenTemplate uses Github Action as the CI, the workflow files locate under [.github/workflows/](https://github.com/nimblehq/elixir-templates/tree/develop/.github/workflows) directory.

There are 2 types of test **Template test** and **Variant test**


### 1/ Template test

All files are located under `test/` directory.

```
.
├── ...
├── test
│   ├── ...
│   ├── nimble.phx.gen.template
│   │   └── addons
│   │   │   ├── ...
│   │   │   ├── common_addon_test.exs
│   │   │   └── variants
│   │   │   │   └── api
│   │   │   │   │   ├── ...
│   │   │   │   │   └── api_addon_test.exs
│   │   │   │   └── web
│   │   │   │   │   ├── ...
│   │   │   │   │   └── web_addon_test.exs
```

### 2/ Variant test

#### 2.1/ Variant

NimblePhxGenTemplate is supporting 3 variants:  

- API
- Web
- Live

#### 2.2/ Phoenix project

The Phoenix project could be either a Web project or API project.

- Web variant supports HTML and Webpack configuration.

```bash
mix phx.new your_app_name
```

- API variant does NOT support HTML and Webpack configuration.

```bash
mix phx.new your_app_name --no-html --no-webpack
```

- Custom project variant allow us to modify the app name or module name.

```bash
# Use CustomModuleName
mix phx.new your_app_name --module=CustomModuleName

# Use custom otp app name
mix phx.new AppName --app=custom_otp_app_name
# Use custom module and app name
mix phx.new AppName --module=CustomModuleName --app=custom_otp_app_name
```

So it ends up with 6 project types:

- Standard Web project (`mix phx.new your_app_name`)
- Custom Web project (`mix phx.new your_app_name --module=CustomModuleName --app=custom_otp_app_name`)
- Standard API project (`mix phx.new your_app_name --no-html --no-webpack`)
- Custom API project (`mix phx.new your_app_name --no-html --no-webpack --module=CustomModuleName --app=custom_otp_app_name`)
- Standard LiveView project (`mix phx.new your_app_name --live`)
- Custom LiveView project (`mix phx.new your_app_name --live --module=CustomModuleName --app=custom_otp_app_name`)

Putting it all together, there are 8 variants test cases.

- Applying the `API variant` to a `Standard Web project`
- Applying the `API variant` to a `Custom Web project`
- Applying the `API variant` to a `Standard API project`
- Applying the `API variant` to a `Custom API project`
- Applying the `Web variant` to a `Standard Web project`
- Applying the `Web variant` to a `Custom Web project`
- Applying the `Live variant` to a `Standard LiveView project`
- Applying the `Live variant` to a `Custom LiveView project`

### Release

Set the `HEX_API_KEY` as a Github secret (skip this step if it has been done).

The release process follows the [Git flow](https://nimblehq.co/compass/development/version-control/release-management).

Once a `release/<version number>` is created, to publish the new version to Hex.pm, the version number in the `mix.ex` file needs to be updated on the release branch before merging.

Once the release branch is merged into the `master` branch, Github Action automatically publishes the template to [https://hex.pm/packages/nimble_phx_gen_template](https://hex.pm/packages/nimble_phx_gen_template).


## Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/nimblehq/elixir-templates/issues). 

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

