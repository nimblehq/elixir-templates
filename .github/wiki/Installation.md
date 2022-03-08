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

  - `mix nimble_template.gen --api`
  - `mix nimble_template.gen --live`
  - `mix nimble_template.gen --web`

8. Answer the interactive prompt that will be displayed during the setup