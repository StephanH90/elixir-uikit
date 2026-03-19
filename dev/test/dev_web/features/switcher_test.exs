defmodule DevWeb.Features.SwitcherTest do
  use DevWeb.FeatureCase, async: false

  @moduletag :browser

  feature "clicking tab in subnav switches content pane", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#switcher")
    |> click(css("#nav-switcher-demo-item-1 a"))
    |> assert_has(css("#switcher-demo > li.uk-active", text: "Content 2"))
  end

  feature "server button changes active switcher pane", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#programmatic-switcher")
    |> click(button("Show Pane 2"))
    |> assert_has(css("#prog-switcher > li.uk-active", text: "Content 2"))
    |> assert_has(css("#prog-pane-1.uk-active"))
  end

  feature "clicking tab pushes event to server with index", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#programmatic-switcher")
    |> click(css("#prog-pane-2-link"))
    |> assert_has(css("#prog-switcher > li.uk-active", text: "Content 3"))
    |> assert_has(css("#prog-pane-2.uk-active"))
  end
end
