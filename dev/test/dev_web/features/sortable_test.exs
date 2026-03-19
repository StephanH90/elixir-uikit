defmodule DevWeb.Features.SortableTest do
  use DevWeb.FeatureCase, async: false

  @moduletag :browser

  feature "page renders all 3 sortable items", %{session: session} do
    session
    |> visit("/sortable")
    |> wait_for_liveview()
    |> assert_has(css("#my-sortable #item-1"))
    |> assert_has(css("#my-sortable #item-2"))
    |> assert_has(css("#my-sortable #item-3"))
  end

  feature "reorder event via JS pushEvent updates server state", %{session: session} do
    session
    |> visit("/sortable")
    |> wait_for_liveview()

    # Simulate a reorder by pushing the event directly through the LiveView hook.
    # Real drag-and-drop is fragile in headless Chrome — this tests the important
    # server-side round-trip.
    session
    |> execute_script("""
      const el = document.getElementById("my-sortable");
      const view = window.liveSocket.getViewByEl(el.closest("[data-phx-main]"));
      view.pushEvent("uikit:reorder", el, null, "uikit:reorder", {items: ["item-3", "item-1", "item-2"]});
    """)

    session
    |> assert_has(css("pre", text: "item-3"))
  end
end
