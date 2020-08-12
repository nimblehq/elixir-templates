ARG ELIXIR_IMAGE=elixir:1.9.0-alpine
ARG APP_IMAGE=alpine:3.9
ARG APP_NAME=nimble
ARG APP_HOME=/nimble
ARG APP_GROUP=app_group
ARG APP_USER=app_user

#####################
####### Build #######
#####################
FROM $ELIXIR_IMAGE AS builder

ARG APP_HOME

WORKDIR $APP_HOME

# Install build dependencies
RUN apk add --no-cache build-base npm git && \
    mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod

COPY . .

# Install mix dependencies
RUN mix do deps.get, deps.compile

# Build assets
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error && \
    npm run --prefix ./assets deploy && \
    mix phx.digest

# Compile and build release
RUN mix do compile, release

#####################
###### Release ######
#####################
FROM $APP_IMAGE AS app

ARG APP_NAME
ARG APP_HOME
ARG APP_USER
ARG APP_GROUP

RUN apk add --no-cache openssl ncurses-libs

WORKDIR $APP_HOME

# Setup non-root user
RUN addgroup -S $APP_GROUP && \
    adduser -s /bin/sh -G $APP_GROUP -D $APP_USER && \
    chown $APP_USER:$APP_GROUP $APP_HOME

# Copy release build from builder
COPY --from=builder --chown=$APP_USER:$APP_GROUP $APP_HOME/_build/prod/rel/$APP_NAME ./

USER $APP_USER

CMD ["bin/nimble", "start"]
