defmodule DevWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use DevWeb, :html

  embed_templates("layouts/*")

  @doc """
  Renders your app layout.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")

  attr(:current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
  )

  slot(:inner_block, required: true)

  def app(assigns) do
    ~H"""
    <nav class="uk-navbar-container" uk-navbar>
      <div class="uk-navbar-left">
        <a href="/" class="uk-navbar-item uk-logo">
          <img src={~p"/images/logo.svg"} width="36" />
          <span class="uk-text-small uk-margin-small-left">
            v{Application.spec(:phoenix, :vsn)}
          </span>
        </a>
      </div>
      <div class="uk-navbar-right">
        <ul class="uk-navbar-nav">
          <li>
            <a href="https://phoenixframework.org/">Website</a>
          </li>
          <li>
            <a href="https://github.com/phoenixframework/phoenix">GitHub</a>
          </li>
          <li>
            <a href="https://hexdocs.pm/phoenix/overview.html">
              Get Started &rarr;
            </a>
          </li>
        </ul>
      </div>
    </nav>

    <main>
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr(:flash, :map, required: true, doc: "the map of flash messages")
  attr(:id, :string, default: "flash-group", doc: "the optional id of flash container")

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title="We can't find the internet"
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        Attempting to reconnect
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title="Something went wrong!"
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        Attempting to reconnect
      </.flash>
    </div>
    """
  end
end
