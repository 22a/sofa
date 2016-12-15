# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sofa,
  ecto_repos: [Sofa.Repo]

# Configures the endpoint
config :sofa, Sofa.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5PNk5bM3CmkR6fkOKV6Oq5RmIFOA6+eTCJ5saj7fAmGO/NzHCWVy5U1j3QP29wcJ",
  render_errors: [view: Sofa.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sofa.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Sofa.User,
  repo: Sofa.Repo,
  module: Sofa,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :invitable, :registerable]

config :coherence, Sofa.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%

config :pooler, pools:
  [
    [
      name: :riak01,
      group: :riak,
      max_count: 10,
      init_count: 5,
      start_mfa: { Riak.Connection, :start_link, ['0.0.0.0', 32769] }
    ], [
      name: :riak02,
      group: :riak,
      max_count: 10,
      init_count: 5,
      start_mfa: { Riak.Connection, :start_link, ['0.0.0.0', 32771] }
    ], [
      name: :riak03,
      group: :riak,
      max_count: 10,
      init_count: 5,
      start_mfa: { Riak.Connection, :start_link, ['0.0.0.0', 32773] }
    ], [
      name: :riak04,
      group: :riak,
      max_count: 10,
      init_count: 5,
      start_mfa: { Riak.Connection, :start_link, ['0.0.0.0', 32775] }
    ], [
      name: :riak05,
      group: :riak,
      max_count: 10,
      init_count: 5,
      start_mfa: { Riak.Connection, :start_link, ['0.0.0.0', 32777] }
    ]
  ]
