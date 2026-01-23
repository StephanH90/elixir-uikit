defmodule Uikit.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_uikit,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      description: "UIkit components and LiveView hooks for Phoenix.",
      package: package(),
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{},
      files: files()
    ]
  end

  defp files do
    [
      "lib",
      "AGENTS.md",
      "mix.exs",
      "README.md",
      "assets"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tidewave, "~> 0.5", only: [:dev]},
      {:usage_rules, "~> 0.1", only: [:dev]},
      {:igniter, "~> 0.6", optional: true},
      {:phoenix, "~> 1.8.3"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_html, "~> 4.0"},
      {:quokka, "~> 2.11", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end
