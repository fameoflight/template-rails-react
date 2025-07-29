# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :template_phoenix_api,
  ecto_repos: [TemplatePhoenixApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :template_phoenix_api, TemplatePhoenixApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TemplatePhoenixApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TemplatePhoenixApi.PubSub,
  live_view: [signing_salt: "HZA/Roo+"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :template_phoenix_api, TemplatePhoenixApi.Mailer,
  adapter: Swoosh.Adapters.Local  # Use Local for development, Postmark for production

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Disable Tesla deprecated builder warning
config :tesla, disable_deprecated_builder_warning: true

# Add msgpack MIME type support
config :mime, :types, %{
  "application/msgpack" => ["msgpack"]
}


# Guardian configuration
config :template_phoenix_api, TemplatePhoenixApi.Guardian,
  issuer: "template_phoenix_api",
  secret_key: "your-secret-key-here"

# Oban configuration
config :template_phoenix_api, Oban,
  repo: TemplatePhoenixApi.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, mailer: 20]

# Ueberauth configuration
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
