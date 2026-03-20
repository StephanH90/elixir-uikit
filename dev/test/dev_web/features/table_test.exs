defmodule DevWeb.Features.TableTest do
  use DevWeb.FeatureCase, async: false

  @moduletag :browser

  feature "table section is visible on home page", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#table")
    |> assert_has(css("#table table.uk-table", minimum: 1))
  end

  feature "striped table has correct CSS class", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#table")
    |> assert_has(css("#table table.uk-table-striped", minimum: 1))
  end

  feature "hover table has correct CSS class", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#table")
    |> assert_has(css("#table table.uk-table-hover", minimum: 1))
  end

  feature "responsive table is wrapped in overflow-auto container", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#table")
    |> assert_has(css("#table .uk-overflow-auto table.uk-table", minimum: 1))
  end

  feature "live table shows initial rows", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#live-table")
    |> assert_has(css("#table-row-1"))
    |> assert_has(css("#table-row-2"))
    |> assert_has(css("#table-row-3"))
  end

  feature "clicking Add Row appends a new row to the live table", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#live-table")
    |> click(button("Add Row"))
    |> assert_has(css("#table-row-4"))
  end

  feature "multiple row additions accumulate in the live table", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#live-table")
    |> click(button("Add Row"))
    |> click(button("Add Row"))
    |> assert_has(css("#table-row-4"))
    |> assert_has(css("#table-row-5"))
  end
end
