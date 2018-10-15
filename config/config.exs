# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  ecto_repos: [Api.Repo]

# Configures the endpoint
config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IT608FKzjY8mLnLYYnxCFz0d7kZa/G0PjnhkRgsQ1+zjGGmt6TEXmP28+VXabp2z",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
config :api, Api.Guardian,
  issuer: "api",
  secret_key: "5daO4Zr5L6BZg3nidm3BXctMPPuGXunVBjX46J1cSZpKE/gW115guClh53rg6ZSy"

import_config "#{Mix.env}.exs"
