# Uikit

UIkit components and LiveView hooks for Phoenix applications.

## Installation

Add `elixir_uikit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_uikit, "~> 0.2.1"}
  ]
end
```

## JavaScript Setup

This library provides LiveView hooks (e.g. for Sortable). To use them, you need to add the JavaScript dependency and register the hooks.

1.  Add `uikit_ex` and `uikit` to your `assets/package.json` dependencies:

    ```json
    {
      "dependencies": {
        "uikit": "^3.0.0",
        "uikit_ex": "file:../deps/uikit"
      }
    }
    ```

2.  Run `npm install` inside your `assets` directory.

3.  Import and register the hooks in `assets/js/app.js`:

    ```javascript
    import { Socket } from "phoenix"
    import { LiveSocket } from "phoenix_live_view"
    
    // Import UIkit and the hooks
    import UIkit from "uikit"
    import Icons from "uikit/dist/js/uikit-icons"
    import UikitHooks from "uikit_ex"

    // Initialize UIkit
    UIkit.use(Icons)
    window.UIkit = UIkit

    let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
    let liveSocket = new LiveSocket("/live", Socket, {
      params: { _csrf_token: csrfToken },
      // Register the hooks
      hooks: { ...UikitHooks }
    })
    
    // ...
    ```

## CSS Setup

Ensure you have UIkit styles loaded. You can import them in your `assets/css/app.css` (if using css import support) or `assets/css/app.scss`:

```scss
/* assets/css/app.scss */
@import "../node_modules/uikit/dist/css/uikit.min.css";
```

Or allow your build tool (like Sass) to handle the imports as needed.

## Usage

### Components

Import the components in your `lib/my_app_web.ex` file under `html_helpers`:

```elixir
defp html_helpers do
  quote do
    # ...
    import Uikit.Components
    # ...
  end
end
```

Then you can use components like `<.uk_button>`, `<.uk_card>`, etc.

### Sortable Example

```heex
<.uk_sortable group="my-group" grid id="sortable-list" phx-hook="Sortable">
  <div :for={item <- @items} id={item.id}>
    {item.text}
  </div>
</.uk_sortable>
```

Handle the `uikit:reorder` event in your LiveView:

```elixir
def handle_event("uikit:reorder", %{"items" => item_ids}, socket) do
  # item_ids contains the list of IDs in the new order
  {:noreply, socket}
end
```