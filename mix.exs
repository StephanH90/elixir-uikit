defmodule Uikit.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_uikit,
      version: "0.5.2",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      description: "UIkit components and LiveView hooks for Phoenix.",
      package: package(),
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      usage_rules: usage_rules()
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
      "priv",
      "AGENTS.md",
      "mix.exs",
      "README.md",
      "assets",
      "usage-rules.md",
      "usage-rules"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tidewave, "~> 0.5", only: [:dev]},
      {:usage_rules, "~> 1.1", only: [:dev]},
      {:igniter, "~> 0.6", only: [:dev]},
      {:phoenix, "~> 1.8.3"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_html, "~> 4.0"},
      {:quokka, "~> 2.11", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp usage_rules do
    # Example for those using claude.
    [
      file: "CLAUDE.md",
      # rules to include directly in CLAUDE.md
      # use a regex to match multiple deps, or atoms/strings for specific ones
      # If your CLAUDE.md is getting too big, link instead of inlining:
      # or use skills
      skills: [
        location: ".claude/skills",
        # build skills that combine multiple usage rules
        build: [
          "phoenix-framework": [
            description:
              "Use this skill working with Phoenix Framework. Consult this when working with the web layer, controllers, views, liveviews etc.",
            # Include all Phoenix dependencies
            usage_rules: [:phoenix, ~r/^phoenix_/]
          ]
        ]
      ]
    ]
  end
end
