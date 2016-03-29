# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :therm_log, 
  :dbname, "./db/dev/therm_log.sqlite3"

config :thermex, :base_path, Path.join([__DIR__, "..", "test", "fixtures"])

  # import_config "#{Mix.env}.exs"
