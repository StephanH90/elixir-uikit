defmodule DevWeb.Features.FormTest do
  use DevWeb.FeatureCase, async: false

  @moduletag :browser

  feature "submit empty form shows validation errors", %{session: session} do
    session
    |> visit("/forms")
    |> wait_for_liveview()
    |> click(button("Save"))
    |> assert_has(css(".uk-form-danger", minimum: 1))
    |> refute_has(css(".uk-alert-success"))
  end

  feature "fill valid data and submit shows success banner", %{session: session} do
    session
    |> visit("/forms")
    |> wait_for_liveview()
    |> fill_in(css("input[name='user[name]']"), with: "Jane Smith")
    |> fill_in(css("input[name='user[email]']"), with: "jane@example.com")
    |> fill_in(css("input[name='user[password]']"), with: "password123")
    |> click(css("select[name='user[role]']"))
    |> click(css("select[name='user[role]'] option[value='admin']"))
    |> click(button("Save"))
    |> assert_has(css(".uk-alert-success", text: "Submitted successfully!"))
  end

  feature "typing short name and blurring shows inline validation error", %{session: session} do
    session
    |> visit("/forms")
    |> wait_for_liveview()
    |> fill_in(css("input[name='user[name]']"), with: "J")
    # Trigger phx-change by moving focus to another field
    |> click(css("input[name='user[email]']"))
    |> assert_has(css(".uk-form-danger", minimum: 1))
  end

  feature "click reset clears the form", %{session: session} do
    session
    |> visit("/forms")
    |> wait_for_liveview()
    |> fill_in(css("input[name='user[name]']"), with: "Jane Smith")
    |> fill_in(css("input[name='user[email]']"), with: "jane@example.com")
    |> click(button("Reset"))
    |> assert_has(css("input[name='user[name]'][value='']"))
  end
end
