# Adding a new addon

There are 3 types of addons
1. API
2. Live
3. Web

For example, to add a new web addon, create a new file at `lib/nimble_template/addons/variants/phoenix/web/sample_addon.ex`

```
defmodule NimbleTemplate.Addons.Phoenix.Web.SampleAddon do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @impl true
  def do_apply(%Project{} = project, opts) do
    project
  end
end
```

The module should implement `do_apply` callbacks of a behaviour

With a new corresponding test file at `test/nimble_template/addons/variants/phoenix/web/addon_test.exs`

Then call `NimbleTemplate.Addons.Phoenix.Web.SampleAddon.apply(project)` inside `lib/nimble_template/templates/variants/phoenix/web/template.ex` which will be executed on Terminal prompt

## Functions from NimbleTemplate.Generator

`Generator.replace_content(path, content_to_find, content_to_replace)`

Find and replace specified content in an existing file

Example
```
  Generator.replace_content(
    "assets/package.json",
    """
      "dependencies": {
    """,
    """
      "dependencies": {
        "@popperjs/core": "^2.11.2",
        "bootstrap": "5.1.3",
    """
  )
```

`Generator.append_content(path, content)`

Append specified content to an existing file

Example
```
  Generator.append_content(
    "assets/css/_variables.scss",
    """
    Content
    """
  )
```

`Generator.create_file(path, content, options \\ [])`

Create a new file with specified content

Example
```
  Generator.create_file(
    "assets/css/_variables.scss",
    """
    Content
    """
  )
```

# Run unit test on local

`mix test`

# Apply the whole template on local

See [[Installation]]

# FAQ
