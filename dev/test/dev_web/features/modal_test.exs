defmodule DevWeb.Features.ModalTest do
  use DevWeb.FeatureCase, async: false

  @moduletag :browser

  feature "open basic modal via uk-toggle and close via close button", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#modal")
    |> click(button("Basic Modal"))
    |> assert_has(css("#demo-modal.uk-open", count: 1))
    |> click(css("#demo-modal .uk-modal-close"))
    |> assert_has(css("#demo-modal.uk-open", count: 0, visible: :any))
  end

  feature "programmatic modal opens via server assign", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#programmatic-modal")
    |> click(button("Open from Server"))
    |> assert_has(css("#prog-modal.uk-open", count: 1))
  end

  feature "programmatic modal closes via server button", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#programmatic-modal")
    |> click(button("Open from Server"))
    |> assert_has(css("#prog-modal.uk-open", count: 1))
    |> click(css("#prog-modal .uk-modal-footer button"))
    |> assert_has(css("#prog-modal.uk-open", count: 0, visible: :any))
  end

  feature "programmatic modal closes on Escape and syncs back to server", %{session: session} do
    session
    |> visit("/")
    |> wait_for_liveview()
    |> scroll_to("#programmatic-modal")
    |> click(button("Open from Server"))
    |> assert_has(css("#prog-modal.uk-open", count: 1))
    |> send_keys([:escape])
    |> assert_has(css("#prog-modal.uk-open", count: 0, visible: :any))
    # Verify server assign was reset — modal can be reopened
    |> click(button("Open from Server"))
    |> assert_has(css("#prog-modal.uk-open", count: 1))
  end
end
