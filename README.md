# Elixir UIkit

UIkit components and LiveView hooks for Phoenix applications. No Node.js required.

Full documentation is available at [hexdocs.pm/elixir_uikit](https://hexdocs.pm/elixir_uikit).

## Installation

Add `elixir_uikit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_uikit, "~> 0.5.0"}
  ]
end
```

Then run the setup task:

```bash
mix deps.get
mix uikit.setup
```

This will:

- Remove Tailwind CSS, DaisyUI, and heroicons
- Add and configure `dart_sass` for SCSS compilation
- Set up `assets/js/app.js` with UIkit imports and LiveView hooks
- Create `assets/css/app.scss` with UIkit SCSS imports
- Add component imports to your web module

UIkit's JS and SCSS files are shipped with this package — everything is resolved
from `deps/elixir_uikit`, so no npm or Node.js installation is needed.

After setup, run `mix deps.get` again to fetch `dart_sass`, then start your server:

```bash
mix deps.get
mix phx.server
```

## Usage

Components are automatically imported by the installer. Use them in your HEEx templates:

```heex
<.uk_button variant="primary">Click me</.uk_button>

<.uk_card>
  <:header><.uk_card_title>Title</.uk_card_title></:header>
  <:body>Card content</:body>
</.uk_card>
```

### Available Components

- `uk_button`, `uk_badge`, `uk_label`, `uk_icon`, `uk_spinner`
- `uk_card`, `uk_card_title`, `uk_container`, `uk_section`, `uk_grid`
- `uk_modal`, `uk_modal_title`, `uk_sortable`, `uk_subnav`, `uk_switcher`

### Form Components

- `uk_form`, `uk_input`, `uk_checkbox`, `uk_radio`, `uk_range`
- `uk_fieldset`, `uk_form_label`, `uk_form_controls`, `uk_form_icon`

### LiveView Hooks

The installer sets up three hooks automatically:

**Sortable** — drag-and-drop reordering:

```heex
<.uk_sortable id="my-list" phx-hook="Sortable">
  <div :for={item <- @items} id={item.id}>{item.text}</div>
</.uk_sortable>
```

```elixir
def handle_event("uikit:reorder", %{"items" => item_ids}, socket) do
  {:noreply, socket}
end
```

**Modal** — server-controlled show/hide:

```heex
<.uk_modal id="my-modal" show={@show_modal} on_close="close_modal">
  <:title>Modal Title</:title>
  Modal content here.
</.uk_modal>
```

**Switcher** — tab switching with server sync:

```heex
<.uk_subnav id="tabs" switcher active={@active_tab} on_change="tab_changed">
  <:item id="tab-1">Tab 1</:item>
  <:item id="tab-2">Tab 2</:item>
</.uk_subnav>
```

## SCSS Customization

The installer configures dart_sass with a load path pointing to UIkit's SCSS source.
You can customize UIkit variables by overriding them in `assets/css/app.scss` before the imports:

```scss
// Override UIkit variables
$global-primary-background: #1e87f0;

// UIkit (loaded via dart_sass --load-path)
@import "variables-theme";
@import "mixins-theme";
@import "uikit-theme";

/* Your custom styles below */
```
