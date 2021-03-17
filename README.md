# NimblePhxGenTemplate

Project repository template to set up all public Phoenix projects at [Nimble](https://nimblehq.co/)

## Installation

### Generate a new Phoenix project by using [mix phx.new](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html)

```bash
mix phx.new helloElixirApp
```

### Adding `nimble_phx_gen_template` into `mix.exs`:

```elixir
def deps do
  [
    {:nimble_phx_gen_template, "~> 2.2.0", only: :dev, runtime: false},
    ...
  ]
end
```

Then run `mix do deps.get, deps.compile` to install NimblePhxGenTemplate.

*Note:* NimblePhxGenTemplate is only working on a new Phoenix project, applying NimblePhxGenTemplate to an existing Phoenix project might not work as expected.

## Usage

```
mix nimble.phx.gen.template -v # Print the version
mix nimble.phx.gen.template --web # Apply the Web template
mix nimble.phx.gen.template --api # Apply the API template
mix nimble.phx.gen.template --live # Apply the LiveView template
```
## Requirements

NimblePhxGenTemplate has been developed and actively tested with:
- Elixir 1.11.3
- Erlang/OTP 23.2.1
- Phoenix 1.5.7

Running NimblePhxGenTemplate currently requires:
- Elixir 1.11.3
- Erlang/OTP 23.2.1
- Phoenix 1.5.7

## Contributing

We appreciate any contribution to NimblePhxGenTemplate.

### Test

NimblePhxGenTemplate is using Github Action, the workflow files are located under `.github/workflows/` folder, it's including the Template test and Variant test workflow.

#### 1/ Template test

All files are located under `test/` folder.

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

#### 2/ Variant test

##### 2.1/ Variant

NimblePhxGenTemplate is supporting 3 variants:  

- API
- Web
- Live

##### 2.2/ Phoenix project

The Phoenix project could be either a Web project or API project.

- Web project is including HTML and Webpack configuration, which was generated by `mix phx.new appName`.

- API project is NOT including HTML and Webpack configuration, which was generated by `mix phx.new appName --no-html --no-webpack`.

Aside from that, it could also be a Custom project, which contains the custom OTP app name or custom module name.

- `mix phx.new appName --module=CustomModuleName`
- `mix phx.new appName --app=custom_otp_app_name`
- `mix phx.new appName --module=CustomModuleName --app=custom_otp_app_name`

So it ends up with 6 project types:

- Standard Web project (`mix phx.new appName`)
- Custom Web project (`mix phx.new appName --module=CustomModuleName --app=custom_otp_app_name`)
- Standard API project (`mix phx.new appName --no-html --no-webpack`)
- Custom API project (`mix phx.new appName --no-html --no-webpack --module=CustomModuleName --app=custom_otp_app_name`)
- Standard LiveView project (`mix phx.new appName --live`)
- Custom LiveView project (`mix phx.new appName --live --module=CustomModuleName --app=custom_otp_app_name`)

Putting it all together, it is 8 variant test cases.

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

The release process follows the [Git flow](https://nimblehq.co/compass/development/version-control/#releases-).

Once a `release/<version number>` is created, to publish the new version to Hex.pm, the version number in the `mix.ex` file needs to be updated on the release branch before merging.

Once the release branch is merged into the `master` branch, Github Action will automatically publish the template to https://hex.pm/packages/nimble_phx_gen_template.

## License

This project is Copyright (c) 2014-2021 Nimble. It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About

![Nimble](https://assets.nimblehq.co/logo/dark/logo-dark-text-160.png)

This project is maintained and funded by Nimble.

We love open source and do our part in sharing our work with the community!
See [our other projects][community] or [hire our team][hire] to help build your product.

[community]: https://github.com/nimblehq
[hire]: https://nimblehq.co/
