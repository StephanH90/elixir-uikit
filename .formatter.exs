# Used by "mix format"
[
  import_deps: [:phoenix],
  plugins: [Phoenix.LiveView.HTMLFormatter, Quokka],
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "dev/{mix,.formatter}.exs",
    "dev/{config,lib,test}/**/*.{ex,exs}"
  ]
]
