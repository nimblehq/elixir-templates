<h1 align="center"> NimblePhxGenTemplate </h1>
<p>
  <img alt="Version" src="https://github.com/nimblehq/elixir-templates/actions/workflows/test_template.yml/badge.svg" />
</p>

> A Library for initialize new Phoenix projects

## Introduction

NimblePhxGenTemplate is a library for initializing new Phoenix projects at [Nimble](https://nimblehq.co/). It saves us a lot of time on the installation and configuration of new Phoenix projects.

It supports for linting, testing, and much more, so developers can focus on core feature of the application. 

## Features

Libraries:
- [wallaby](https://hex.pm/packages/wallaby): Concurrent feature tests for Elixir.
- [sobelow](https://hex.pm/packages/sobelow): Security-focused static analysis for the Phoenix framework.
- [oban](https://hex.pm/packages/oban): Robust job processing, backed by modern PostgreSQL.
- [mimic](https://hex.pm/packages/mimic): Mocks for Elixir functions
- [ex_machina](https://hex.pm/packages/ex_machina): A factory library by the creators of FactoryBot (née FactoryGirl)
- [excoveralls](https://hex.pm/packages/excoveralls): Coverage report tool for Elixir with coveralls.io integration.
- [dialyxir](https://hex.pm/packages/dialyxir): Mix tasks to simplify use of Dialyzer in Elixir projects.
- [credo](https://hex.pm/packages/credo): A static code analysis tool with a focus on code consistency and teaching.

## Prerequisites

**NimblePhxGenTemplate** has been developed and actively tested with the below environment:

- Mix 1.11.4
- Elixir 1.11.4
- Erlang/OTP 23.3
- Phoenix 1.5.7

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
    {:nimble_template, "~> 3.0", only: :dev, runtime: false},
    # other dependencies ...
  ]
end
```

Step 3: Fetch and install dependencies

Run this command in the root of the project directory to install NimbleTemplate.

```bash
mix do deps.get, deps.compile
```

Step 4: Up and running the Phoenix 

Run this command and verify your local website is successfully installed.

```bash
mix do deps.get, deps.compile
```

Step 5:

After the project initialized and ran successfully, please remove `nimble_phx_gen_template` in the `mix.exs` file. Then run this command:

```
mix deps.clean --unused --unlock 
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

NimbleTemplate uses Github Action as the CI, the workflow files locate under [.github/workflows/](https://github.com/nimblehq/elixir-templates/tree/develop/.github/workflows) directory.

There are 2 types of test **Template test** and **Variant test**


### 1/ Template test

All test files are located under `test/` directory.

```
.
├── ...
├── test
│   ├── ...
│   ├── nimble_template
│   │   └── addons
│   │   │   ├── ...
│   │   │   ├── common_addon_test.exs
│   │   │   └── variants
│   │   │   │   └── mix
│   │   │   │   │   ├── ...
│   │   │   │   │   └── mix_addon_test.exs
│   │   │   │   └── phoenix
│   │   │   │   │   └── api
│   │   │   │   │   │   ├── ...
│   │   │   │   │   │   └── api_addon_test.exs
│   │   │   │   │   └── live
│   │   │   │   │   │   ├── ...
│   │   │   │   │   │   └── live_addon_test.exs
│   │   │   │   │   └── web
│   │   │   │   │   │   ├── ...
│   │   │   │   │   │   └── web_addon_test.exs
```

### 2/ Variant test

#### 2.1/ Variant

NimbleTemplate supports 4 variants:  

- API
- Live
- Web
- Mix

#### 2.2/ Phoenix project

The Phoenix project could be either a Web or API project.

- Web variant supports HTML and Webpack configuration.

```bash
mix phx.new awesome_project
```

- LiveView project is including HTML and Webpack configuration.

```bash
mix phx.new awesome_project --live
```

- API variant does NOT support HTML and Webpack configuration.

```bash
mix phx.new awesome_project --no-html --no-webpack
```

- Custom project variant allow us to modify the app name or module name.

```bash
# Use CustomModuleName
mix phx.new awesome_project --module=CustomModuleName

# Use custom OTP app name
mix phx.new awesome_project --app=custom_otp_app_name

# Use custom module and app name
mix phx.new awesome_project --module=CustomModuleName --app=custom_otp_app_name
```

So it ends up with 6 project types:

Web project 
- Standard (`mix phx.new awesome_project`)
- Custom (`mix phx.new awesome_project --module=CustomModuleName --app=custom_otp_app_name`)

API project
- Standard (`mix phx.new awesome_project --no-html --no-webpack`)
- Custom (`mix phx.new awesome_project --no-html --no-webpack --module=CustomModuleName --app=custom_otp_app_name`)

LiveView project
- Standard (`mix phx.new awesome_project --live`)
- Custom (`mix phx.new awesome_project --live --module=CustomModuleName --app=custom_otp_app_name`)

Putting it all together, there are 8 variants of test cases.

- Applying the `API variant` to a `Standard Web project`
- Applying the `API variant` to a `Custom Web project`
- Applying the `API variant` to a `Standard API project`
- Applying the `API variant` to a `Custom API project`
- Applying the `Web variant` to a `Standard Web project`
- Applying the `Web variant` to a `Custom Web project`
- Applying the `Live variant` to a `Standard LiveView project`
- Applying the `Live variant` to a `Custom LiveView project`

##### 2.2/ Mix project

The Mix project could be either a Standard project or a Custom project.

- `mix new awesome_project`
- `mix new awesome_project --module=CustomModuleName`
- `mix new awesome_project --app=custom_otp_app_name`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name`

Each project could be include the `supervision tree` or not.

- `mix new awesome_project`
- `mix new awesome_project --sup`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name --sup`

Putting it all together, it will has 4 variant test cases.

- Applying the `Mix variant` to a `Standard Mix project`
- Applying the `Mix variant` to a `Custom Mix project`
- Applying the `Mix variant` to a `Standard Mix project with the --sup option`
- Applying the `Mix variant` to a `Custom Mix project with the --sup option`

### Release

Set the `HEX_API_KEY` as a Github secret (skip this step if it has been done).

The release process follows the [Git flow](https://nimblehq.co/compass/development/version-control/release-management).

Once a `release/<version number>` is created, to publish the new version to Hex.pm, the version number in the `mix.ex` file needs to be updated on the release branch before merging.

Once the release branch is merged into the `master` branch, Github Action automatically publishes the template to [https://hex.pm/packages/nimble_template](https://hex.pm/packages/nimble_template).


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
