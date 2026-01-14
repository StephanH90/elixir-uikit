defmodule Mix.Tasks.Uikit.Update.Docs do
  @moduledoc false

  @spec short_doc() :: String.t()
  def short_doc do
    "Downloads the most recent minified version of uikit and puts it in the priv/static directory"
  end

  def long_doc do
    "Downloads the most recent minified version of uikit and puts it in the priv/static directory"
  end
end

if Code.ensure_loaded?(Igniter) do
  defmodule Mix.Tasks.Uikit.Update do
    @shortdoc "#{__MODULE__.Docs.short_doc()}"

    use Igniter.Mix.Task

    @impl Igniter.Mix.Task
    def igniter(igniter) do
      {:ok, _} = Application.ensure_all_started(:req)

      with {:ok, %{body: body}} <-
             Req.get(
               "https://raw.githubusercontent.com/uikit/uikit/refs/heads/develop/dist/css/uikit.min.css"
             ) do
        File.write("priv/static/uikit.min.css", body)
      end

      igniter
      |> Igniter.add_notice("Uikit has been updated in placed in priv/static/css")
    end
  end
else
  defmodule Mix.Tasks.Uikit.Update do
    @shortdoc "#{__MODULE__.Docs.short_doc()} | Install `igniter` to use"

    @moduledoc __MODULE__.Docs.long_doc()

    use Mix.Task

    @impl Mix.Task
    def run(_argv) do
      Mix.shell().error("""
      The task 'uikit.update' requires igniter. Please install igniter and try again.

      For more information, see: https://hexdocs.pm/igniter/readme.html#installation
      """)

      exit({:shutdown, 1})
    end
  end
end
