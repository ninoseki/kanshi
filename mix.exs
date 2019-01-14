defmodule Kanshi.MixProject do
  use Mix.Project

  def project do
    [
      app: :kanshi,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      source_url: "https://github.com/ninoseki/kanshi"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Kanshi.Application, []},
      extra_applications: [:logger, :websockex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:exvcr, "~> 0.10", only: :test},
      {:httpoison, "~> 1.4"},
      {:poison, "~> 4.0"},
      {:websockex, "~> 0.4.2"}
    ]
  end
end
