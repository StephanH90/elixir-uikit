defmodule Mix.Tasks.Uikit.Setup.Docs do
  @moduledoc false

  @spec short_doc() :: String.t()
  def short_doc do
    "Sets up UIkit in your Phoenix application — no Node.js required"
  end

  @spec example() :: String.t()
  def example do
    "mix uikit.setup"
  end

  @spec long_doc() :: String.t()
  def long_doc do
    """
    #{short_doc()}

    UIkit's JS and SCSS source files are shipped with the `elixir_uikit` package.
    This task configures your project to use them directly from `deps/elixir_uikit`
    — nothing is vendored into your project.

    This task will:

    - Remove Tailwind CSS, DaisyUI, and heroicons
    - Add and configure `dart_sass` with a load path into the dep's SCSS
    - Configure esbuild aliases to resolve UIkit JS from the dep
    - Set up `assets/js/app.js` with UIkit imports and LiveView hooks
    - Create `assets/css/app.scss` with UIkit SCSS imports
    - Add UIkit component imports to your web module

    No Node.js or npm installation is required.

    ## Example

    ```sh
    #{example()}
    ```
    """
  end
end

if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Uikit.Setup do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    @moduledoc __MODULE__.Docs.long_doc()

    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def info(_argv, _composing_task) do
      %Igniter.Mix.Task.Info{
        group: :elixir_uikit,
        example: __MODULE__.Docs.example(),
        installs: [{:dart_sass, "~> 0.7", only: :dev}]
      }
    end

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      app_name = Igniter.Project.Application.app_name(igniter)

      igniter
      |> Igniter.Project.Deps.add_dep({:dart_sass, "~> 0.7", only: :dev})
      |> remove_tailwind()
      |> configure_dart_sass(app_name)
      |> setup_javascript()
      |> setup_stylesheet()
      |> add_component_imports()
      |> Igniter.add_notice("""
      UIkit has been set up successfully — no Node.js required!

      Next steps:
        1. Run `mix deps.get` to fetch dart_sass
        2. Restart your Phoenix server

      You can now use UIkit components in your templates:

          <.uk_button variant="primary">Click me</.uk_button>
      """)
    end

    # ── Remove Tailwind ──────────────────────────────────────────────────

    defp remove_tailwind(igniter) do
      igniter
      |> Igniter.Project.Deps.remove_dep(:tailwind)
      |> Igniter.Project.Deps.remove_dep(:heroicons)
      |> remove_tailwind_config()
      |> remove_tailwind_watcher()
      |> remove_tailwind_aliases()
      |> remove_tailwind_vendor_files()
    end

    defp remove_tailwind_config(igniter) do
      Igniter.update_file(igniter, "config/config.exs", fn source ->
        content = Rewrite.Source.get(source, :content)

        new_content =
          Regex.replace(
            ~r/\n*# Configure tailwind[^\n]*\nconfig :tailwind,\n(?:[ \t]+[^\n]*\n)*/,
            content,
            ""
          )

        Rewrite.Source.update(source, :content, fn _ -> new_content end)
      end)
    end

    defp remove_tailwind_watcher(igniter) do
      Igniter.update_file(igniter, "config/dev.exs", fn source ->
        content = Rewrite.Source.get(source, :content)

        new_content =
          content
          |> String.replace(~r/,?\s*tailwind:\s*\{Tailwind[^}]*\}/s, "")
          |> String.replace(~r/tailwind:\s*\{Tailwind[^}]*\},?\s*/s, "")

        Rewrite.Source.update(source, :content, fn _ -> new_content end)
      end)
    end

    defp remove_tailwind_aliases(igniter) do
      Igniter.update_file(igniter, "mix.exs", fn source ->
        content = Rewrite.Source.get(source, :content)
        new_content = String.replace(content, ~r/"tailwind [^"]*"/, "\"sass default\"")
        Rewrite.Source.update(source, :content, fn _ -> new_content end)
      end)
    end

    defp remove_tailwind_vendor_files(igniter) do
      ~w(assets/vendor/heroicons.js assets/vendor/daisyui.js assets/vendor/daisyui-theme.js)
      |> Enum.reduce(igniter, fn file, acc ->
        acc = Igniter.include_existing_file(acc, file, required: false)

        if Igniter.exists?(acc, file) do
          %{acc | rms: [file | acc.rms]}
        else
          acc
        end
      end)
    end

    # ── Configure dart_sass ──────────────────────────────────────────────

    defp configure_dart_sass(igniter, app_name) do
      igniter
      |> Igniter.Project.Config.configure(
        "config.exs",
        :dart_sass,
        [:version],
        "1.77.8",
        updater: fn zipper -> {:ok, Igniter.Code.Common.replace_code(zipper, "1.77.8")} end
      )
      |> Igniter.Project.Config.configure(
        "dev.exs",
        :dart_sass,
        [:default],
        {:code,
         quote do
           [
             args: [
               "--load-path=../deps/elixir_uikit/priv/vendor/uikit/scss",
               "css/app.scss",
               "../priv/static/assets/css/app.css"
             ],
             cd: Path.expand("../assets", __DIR__)
           ]
         end},
        updater: fn zipper ->
          {:ok,
           Igniter.Code.Common.replace_code(
             zipper,
             quote do
               [
                 args: [
                   "--load-path=../deps/elixir_uikit/priv/vendor/uikit/scss",
                   "css/app.scss",
                   "../priv/static/assets/css/app.css"
                 ],
                 cd: Path.expand("../assets", __DIR__)
               ]
             end
           )}
        end
      )
      |> add_sass_watcher(app_name)
    end

    defp add_sass_watcher(igniter, app_name) do
      Igniter.update_file(igniter, "config/dev.exs", fn source ->
        content = Rewrite.Source.get(source, :content)

        new_content =
          if String.contains?(content, "watchers:") do
            Regex.replace(
              ~r/(watchers:\s*\[)\n/,
              content,
              "\\1\n    sass: {\n      DartSass,\n      :install_and_run,\n      [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]\n    },\n"
            )
          else
            Regex.replace(
              ~r/(#{Regex.escape("#{app_name}Web.Endpoint,")})(\s*\n)/,
              content,
              "\\1\\2  watchers: [\n    sass: {\n      DartSass,\n      :install_and_run,\n      [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]\n    }\n  ],\\2"
            )
          end

        Rewrite.Source.update(source, :content, fn _ -> new_content end)
      end)
    end

    # ── JavaScript setup ─────────────────────────────────────────────────

    defp setup_javascript(igniter) do
      igniter
      |> Igniter.include_existing_file("assets/js/app.js", required: false)
      |> Igniter.update_file("assets/js/app.js", fn source ->
        content = Rewrite.Source.get(source, :content)
        new_content = add_uikit_js_imports(content)
        Rewrite.Source.update(source, :content, fn _ -> new_content end)
      end)
    end

    defp add_uikit_js_imports(content) do
      lines = String.split(content, "\n")

      last_import_idx =
        lines
        |> Enum.with_index()
        |> Enum.filter(fn {line, _idx} -> Regex.match?(~r/^import\s/, line) end)
        |> List.last()
        |> case do
          {_line, idx} -> idx
          nil -> -1
        end

      uikit_lines = [
        "",
        "import UIkit from \"../../deps/elixir_uikit/priv/vendor/uikit/js/uikit.min.js\"",
        "import Icons from \"../../deps/elixir_uikit/priv/vendor/uikit/js/uikit-icons.min.js\"",
        "",
        "UIkit.use(Icons)",
        "window.UIkit = UIkit",
        "",
        "import UikitHooks from \"../../deps/elixir_uikit/priv/static/js/elixir_uikit.js\""
      ]

      {before, after_lines} = Enum.split(lines, last_import_idx + 1)
      new_content = Enum.join(before ++ uikit_lines ++ after_lines, "\n")

      cond do
        Regex.match?(~r/hooks:\s*\{\.\.\./, new_content) ->
          Regex.replace(
            ~r/hooks:\s*(\{[^}]*\})/,
            new_content,
            fn _, inner -> "hooks: {#{String.slice(inner, 1..-2//1)}, ...UikitHooks}" end
          )

        Regex.match?(~r/hooks:\s*[a-zA-Z]/, new_content) ->
          Regex.replace(
            ~r/hooks:\s*([a-zA-Z]\w*)/,
            new_content,
            "hooks: {...\\1, ...UikitHooks}"
          )

        Regex.match?(~r/new\s+LiveSocket\s*\(/, new_content) ->
          Regex.replace(
            ~r/(new\s+LiveSocket\s*\(\s*"[^"]+"\s*,\s*Socket\s*,\s*\{)/,
            new_content,
            "\\1\n  hooks: UikitHooks,"
          )

        true ->
          new_content
      end
    end

    # ── Stylesheet setup ─────────────────────────────────────────────────

    defp setup_stylesheet(igniter) do
      css_path = "assets/css/app.css"

      igniter = Igniter.include_existing_file(igniter, css_path, required: false)

      igniter =
        if Igniter.exists?(igniter, css_path) do
          %{igniter | rms: [css_path | igniter.rms]}
        else
          igniter
        end

      Igniter.create_or_update_file(
        igniter,
        "assets/css/app.scss",
        uikit_scss_content(),
        fn source ->
          content = Rewrite.Source.get(source, :content)
          new_content = uikit_scss_content() <> "\n" <> content
          Rewrite.Source.update(source, :content, fn _ -> new_content end)
        end
      )
    end

    defp uikit_scss_content do
      String.trim_leading("""
      // UIkit (loaded via dart_sass --load-path)
      @import "variables-theme";
      @import "mixins-theme";
      @import "uikit-theme";

      /* Add your custom styles below */
      """)
    end

    # ── Component imports ────────────────────────────────────────────────

    defp add_component_imports(igniter) do
      web_module = Igniter.Libs.Phoenix.web_module(igniter)

      Igniter.Project.Module.find_and_update_module!(igniter, web_module, fn zipper ->
        case Igniter.Code.Function.move_to_def(zipper, :html_helpers, 0) do
          {:ok, zipper} ->
            {:ok,
             Igniter.Code.Common.add_code(zipper, """
               import Uikit.Components
               import Uikit.FormComponents
             """)}

          :error ->
            {:ok, zipper}
        end
      end)
    end
  end
else
  defmodule Mix.Tasks.Uikit.Setup do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    @impl Mix.Task
    def run(_argv) do
      Mix.shell().error("""
      The task 'uikit.setup' requires igniter. Please install igniter and try again.

      For more information, see: https://hexdocs.pm/igniter/readme.html#installation
      """)

      exit({:shutdown, 1})
    end
  end
end
