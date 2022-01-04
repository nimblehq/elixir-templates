NimbleTemplate uses Github Actions as the CI, the workflow files are located under the [.github/workflows/](https://github.com/nimblehq/elixir-templates/tree/develop/.github/workflows) directory.

There are 2 types of tests, **Template tests** and **Variant tests**

## 1/ Template test

All test files are located under `test/` directory.

```text
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

## 2/ Variant test

NimbleTemplate supports 4 variants:

- Mix
- Web
- API
- Live

### 2.1/ Mix project

A Mix project could be either a Standard project or a Custom project.

- `mix new awesome_project`
- `mix new awesome_project --module=CustomModuleName`
- `mix new awesome_project --app=custom_otp_app_name`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name`

Each project could include a `supervision tree`.

- `mix new awesome_project`
- `mix new awesome_project --sup`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name --sup`

Adding it all together, totals to 4 variant test cases.

- Applying the `Mix variant` to a `Standard Mix project`
- Applying the `Mix variant` to a `Custom Mix project`
- Applying the `Mix variant` to a `Standard Mix project with the --sup option`
- Applying the `Mix variant` to a `Custom Mix project with the --sup option`

### 2.2/ Phoenix project

A Phoenix project could be either a Web, LiveView, or API.

- Web variants support HTML and Webpack configuration.

```bash
mix phx.new awesome_project
```

- LiveView projects include HTML and Webpack configuration.

```bash
mix phx.new awesome_project --live
```

- API variants do NOT support HTML and Webpack configuration.

```bash
mix phx.new awesome_project --no-html --no-webpack
```

- Custom project variants allow us to modify the app name or module name.

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

## Note

Make sure the Phoenix version is the same between local development and CI, otherwise there will be some error in the unit test.

- Phoenix version on CI can be found in: `.github/workflows/test_template.yml`
- Install a correct Phoenix version on local via command: `mix archive.install hex phx_new __PHOENIX_VERSION__`
