import Config

if Mix.env() == :dev do
  config :git_ops,
    mix_project: Uikit.MixProject,
    changelog_file: "CHANGELOG.md",
    repository_url: "https://github.com/StephanH90/elixir-uikit",
    manage_mix_version?: true,
    manage_readme_version: false,
    version_tag_prefix: "v",
    types: [
      tidbit: [
        hidden?: true
      ],
      important: [
        header: "Important Changes"
      ]
    ]
end
