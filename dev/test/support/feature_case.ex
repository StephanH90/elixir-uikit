defmodule DevWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import DevWeb.FeatureCase.Helpers
      import Wallaby.Query
    end
  end

  defmodule Helpers do
    import Wallaby.Query

    @doc """
    Waits for LiveView to be connected by finding the [data-phx-main] element.
    Wallaby's find already retries until max_wait_time.
    """
    def wait_for_liveview(session) do
      Wallaby.Browser.find(session, css("[data-phx-main]"))
      session
    end

    @doc """
    Scrolls an element into view by CSS selector.
    """
    def scroll_to(session, css_selector) do
      Wallaby.Browser.execute_script(
        session,
        "document.querySelector(arguments[0]).scrollIntoView({behavior: 'instant', block: 'center'})",
        [css_selector]
      )

      session
    end
  end
end
