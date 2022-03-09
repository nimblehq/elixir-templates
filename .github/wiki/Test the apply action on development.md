# Test the apply action on development

1. Clone [Elixir templates](https://github.com/nimblehq/elixir-templates) project to your local directory.

2. Create a new project using `mix phx.new sample_project` or ``mix new sample_project`` command

3. Answer the prompt `Fetch and install dependencies? [Yn]` with `n` (not install)

4. Change directory into `sample_project` using `cd sample_project` command

5. Edit `mix.exs` file and add this line to the dependencies.

```elixir
{:nimble_template, "~> 3.0", path: "~/elixir-templates", only: :dev, runtime: false}
```

Modify the path to locate the `elixir-templates` directory. For example `~/elixir-templates` if inside the home directory.

6. Then go back to the Terminal and run

`mix do deps.get, deps.compile`

7. Choose which template you want to use inside your project

- Web: `mix nimble_template.gen --web`
- Live: `mix nimble_template.gen --api`
- API: `mix nimble_template.gen --live`

8. Answer the interactive prompt that will be displayed during the setup

## Using the Makefile

1. Clone Elixir templates project to your local directory.

2. Generate a new Phoenix project

- Web project: `make create_phoenix_project PROJECT_DIRECTORY=sample_project OPTIONS="--no-live"`
- Live project: `make create_phoenix_project PROJECT_DIRECTORY=sample_project OPTIONS=""`
- API project: `make create_phoenix_project PROJECT_DIRECTORY=sample_project OPTIONS="--no-html --no-assets"`

3. Answer the prompt `Fetch and install dependencies? [Yn]` with `n` (not install)

4. Apply the template

- Web variant: `make apply_phoenix_template PROJECT_DIRECTORY=sample_project VARIANT=web`
- Live variant: `make apply_phoenix_template PROJECT_DIRECTORY=sample_project VARIANT=live`
- API variant: `make apply_phoenix_template PROJECT_DIRECTORY=sample_project VARIANT=api`
