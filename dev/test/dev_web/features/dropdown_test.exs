defmodule DevWeb.Features.DropdownTest do
  use DevWeb.FeatureCase, async: false

  @moduletag :browser

  feature "click button opens dropdown with proper styling", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#dropdown")
    |> click(button("Click Toggle"))
    # The dropdown should have both the uk-dropdown class (for CSS styling)
    # and uk-togglable-enter (UIkit's open state)
    |> assert_has(css(".uk-dropdown.uk-togglable-enter", visible: :any, minimum: 1))
  end

  feature "click nav dropdown shows navigation items", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#dropdown")
    |> click(button("Click Nav"))
    |> assert_has(css(".uk-dropdown.uk-togglable-enter", visible: :any, minimum: 1))
    |> assert_has(css(".uk-dropdown.uk-togglable-enter a", text: "Dashboard"))
  end
end
