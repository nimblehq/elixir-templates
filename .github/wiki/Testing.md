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

Each project could be included the `supervision tree` or not.

- `mix new awesome_project`
- `mix new awesome_project --sup`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name`
- `mix new awesome_project --module=CustomModuleName --app=custom_otp_app_name --sup`

Putting it all together, it has 4 variant test cases.

- Applying the `Mix variant` to a `Standard Mix project`
- Applying the `Mix variant` to a `Custom Mix project`
- Applying the `Mix variant` to a `Standard Mix project with the --sup option`
- Applying the `Mix variant` to a `Custom Mix project with the --sup option`
