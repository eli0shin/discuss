# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, DiscussWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TpET2o/0oRuQ4WkBYGwxT4VFY91I5YV1PJCHEJRPlkiu6FnJQqhe/YISt8w61RZ2",
  render_errors: [view: DiscussWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# ueberauth config
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user,user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "2487f8d2a3c6f24ff058",
  client_secret: "6fc132af9ba75c9d7362cd964f34b3b2b91a2232"
