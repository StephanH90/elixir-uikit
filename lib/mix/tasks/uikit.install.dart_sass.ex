defmodule Mix.Tasks.Uikit.Install.DartSass.Docs do
  @moduledoc false

  @spec short_doc() :: String.t()
  def short_doc do
    "Installs and configures dart_sass for the consuming application"
  end

  @spec example() :: String.t()
  def example do
    "mix uikit.install.dart_sass"
  end

  @spec long_doc() :: String.t()
  def long_doc do
    """
    #{short_doc()}

    This task will:
    - Add dart_sass as a dependency to mix.exs
    - Configure dart_sass in config/config.exs
    - Add dart_sass as a watcher in config/dev.exs
    - Create assets/css directory structure if needed
    - Create a basic app.scss file

    ## Example

    ```sh
    #{example()}
    ```
    """
  end
end

if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Uikit.Install.DartSass do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def info(_argv, _composing_task) do
      %Igniter.Mix.Task.Info{
        group: :uikit,
        adds_deps: [{:dart_sass, "~> 0.7"}],
        installs: [],
        example: __MODULE__.Docs.example(),
        only: nil,
        positional: [],
        composes: [],
        schema: [],
        defaults: [],
        aliases: [],
        required: []
      }
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      app_name = Igniter.Project.Application.app_name(igniter)
      {igniter, endpoint} = Igniter.Libs.Phoenix.select_endpoint(igniter)

      igniter
      |> Igniter.Project.Deps.add_dep({:dart_sass, "~> 0.7"})
      |> configure_dart_sass(app_name)
      |> add_watcher(endpoint)
      |> create_assets_directory()
      |> create_app_scss()
      |> Igniter.add_notice("""
      dart_sass has been installed and configured.

      Next steps:
      1. Run `mix deps.get` to fetch the dependency
      2. Run `mix dart_sass.install` to install the dart_sass binary
      3. Add the compiled CSS to your HTML layout
      4. Start using SCSS in assets/css/app.scss
      """)
    end

    defp configure_dart_sass(igniter, app_name) do
      Igniter.Project.Config.configure(
        igniter,
        "config/config.exs",
        app_name,
        [:dart_sass],
        version: "1.77.0",
        default: [
          args: ~w(css/app.scss ../priv/static/assets/app.css),
          cd: Path.expand("../assets", __DIR__)
        ]
      )
    end

    defp add_watcher(igniter, nil) do
      Igniter.add_warning(
        igniter,
        "Could not find an endpoint to add the dart_sass watcher. Please add it manually to config/dev.exs:\n\n" <>
          "  watchers: [\n" <>
          "    dart_sass: {DartSass, :install_and_run, [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}\n" <>
          "  ]"
      )
    end

    defp add_watcher(igniter, endpoint) do
      Igniter.Project.Config.configure(
        igniter,
        "config/dev.exs",
        endpoint,
        [:watchers],
        [
          dart_sass:
            {DartSass, :install_and_run,
             [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}
        ],
        updater: fn zipper ->
          list_zipper = Igniter.Code.Keyword.get_key(zipper, :dart_sass)

          if list_zipper do
            {:ok, zipper}
          else
            case Igniter.Code.Keyword.put_in_keyword(
                   zipper,
                   [:dart_sass],
                   {DartSass, :install_and_run,
                    [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}
                 ) do
              {:ok, zipper} -> {:ok, zipper}
              :error -> :error
            end
          end
        end
      )
    end

    defp create_assets_directory(igniter) do
      assets_css_path = "assets/css"

      case File.mkdir_p(assets_css_path) do
        :ok ->
          igniter

        {:error, reason} ->
          Igniter.add_warning(
            igniter,
            "Could not create #{assets_css_path} directory: #{inspect(reason)}"
          )
      end
    end

    defp create_app_scss(igniter) do
      app_scss_path = "assets/css/app.scss"

      if File.exists?(app_scss_path) do
        igniter
      else
        app_scss_content = """
        // 1. Your custom variables and variable overwrites.
        // $global-link-color: #DA7D02;

        // 2. Import default variables and available mixins.
        @import "../deps/uikit/src/scss/variables-theme.scss";
        @import "../deps/uikit/src/scss/mixins-theme.scss";

        // 3. Your custom mixin overwrites.
        // @mixin hook-card() { color: #000; }

        // 4. Import UIkit.
        @import "../deps/uikit/src/scss/uikit-theme.scss";
        """

        Igniter.create_new_file(igniter, app_scss_path, app_scss_content)
      end
    end
  end
else
  defmodule Mix.Tasks.Uikit.Install.DartSass do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    @impl Mix.Task
    def run(_argv) do
      Mix.shell().error("""
      The task 'uikit.install.dart_sass' requires igniter. Please install igniter and try again.

      For more information, see: https://hexdocs.pm/igniter/readme.html#installation
      """)

      exit({:shutdown, 1})
    end
  end
end
