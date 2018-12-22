# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :library_api,
  ecto_repos: [LibraryApi.Repo],
  jwt_secret: System.get_env("JWT_SECRET") || "Svcybyh+lHxaGgMfdq7OEwW7pLsf99EfAjk6O07ZELOYYGoYHM+Jrl2ChsAkNV5A"

# Configures the endpoint
config :library_api, LibraryApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZBd2xC3SUMl3xpMJkZLwUJeHXNF3YfPM+n6bbW+wFut9eG7TNAaAT5CeH0/q6tzf",
  render_errors: [view: LibraryApiWeb.ErrorView, accepts: ~w(json json-api)],
  pubsub: [name: LibraryApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :phoenix, :format_encoders, "json-api": Poison


# Configures Elixir's Logger
config :logger, 
  backends: [:console],
  compile_time_purge_level: :debug,
  format: "$time $metadata[$level] $message\n"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
