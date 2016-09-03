defmodule ParticipateApi.Mixfile do
  use Mix.Project

  def project do
    [app: :participate_api,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps,
     preferred_cli_env: [espec: :test, vcr: :test, "vcr.delete": :test,
                         "vcr.check": :test, "vcr.show": :test]]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {ParticipateApi, []},
     applications: [:phoenix, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :httpotion,
                    :ex_machina]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "spec/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:ecto, "~> 2.0", override: true},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:espec, "~> 0.8.22", only: :test},
     {:espec_phoenix, "~> 0.2.1", only: :test, app: false},
     {:ja_serializer, github: "AgilionApps/ja_serializer"},
     {:guardian, "~> 0.12.0"},
     {:exvcr, "~> 0.7", only: :test},
     {:httpotion, "~> 2.1"},
     {:ex_machina, "~> 1.0"},
     {:plug, "~> 1.0"},
     {:corsica, "~> 0.5"}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
