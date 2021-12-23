Prefer to use the image from the Hexpm team instead of the Docker team, the reason below
was mentioned on the [Elixir Forums](https://elixirforum.com/t/yet-another-elixir-and-erlang-docker-image/28740):

- Image tags are not immutable.
- Delay in the availability of new versions.
- Cannot pick the combination of Elixir and Erlang versions you want.

Refer:

- [hexpm/elixir](https://hub.docker.com/r/hexpm/elixir)
- [hexpm/erlang](https://hub.docker.com/r/hexpm/erlang)

Example Dockerfile:

```dockerfile
FROM hexpm/elixir:1.11.0-erlang-23.1.1-alpine-3.12.0 AS build

....
FROM alpine:3.12.0 AS app
...

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/app ./
...
```

Based on the image tag, it's clear which versions we use in the Build Release step

- Elixir: 1.11.0
- Erlang: 23.1.1
- Alpine: 3.12.0

Easily we can choose the OS to run the app on, that is `alpine:3.12.0`
