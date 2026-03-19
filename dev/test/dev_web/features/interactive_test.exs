defmodule DevWeb.Features.InteractiveTest do
  use DevWeb.FeatureCase, async: false

  @moduletag :browser

  feature "clicking 'Add Item with Random Icon' adds a card", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#dynamic-content")
    |> click(button("Add Item with Random Icon"))
    |> assert_has(css("#dynamic-content .uk-card", minimum: 1))
    |> click(button("Add Item with Random Icon"))
    |> assert_has(css("#dynamic-content .uk-card", minimum: 2))
  end

  feature "async loading shows spinner then resolves", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#async-loading")
    |> click(button("Start Async Task"))
    |> assert_has(button("Loading..."))
    # The async task takes 2 seconds — Wallaby's max_wait_time (5s) will handle it
    |> assert_has(button("Start Async Task"))
  end
end
