import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dev, DevWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "NQo0eFXDTQC3IdoIayQSRiy3+EFbMNH8zlTTOvXFyqAuLaHfft+TX5nL50xi3rHv",
  server: true

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :wallaby,
  otp_app: :dev,
  base_url: "http://localhost:4002",
  driver: Wallaby.Chrome,
  max_wait_time: 5_000,
  chromedriver: [
    headless: true,
    path: Path.expand("~/.local/bin/chromedriver")
  ],
  screenshot_on_failure: true,
  screenshot_dir: "tmp/wallaby_screenshots"
