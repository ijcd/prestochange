defmodule PrestoChange.Mixfile do
  use Mix.Project

  def project do
    [
      app: :presto_change,
      version: "0.0.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PrestoChange.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},

      # tags and data
      {:algae, "~> 1.1"},
      {:taggart, "~> 0.1"},
      # {:presto, "~> 0.1"},
      {:floki, "~> 0.20"},

      # dev and test
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:credo, "~> 0.9", only: [:dev, :test]},
      {:dialyxir, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:distillery, "~> 1.5", runtime: false}
    ]
  end
end
