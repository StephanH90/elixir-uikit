# LiveView Hooks

`elixir_uikit` exports five LiveView hooks: **Sortable**, **Modal**, **Icon**, **Dropdown**, and **Switcher**. These are automatically registered when you run `mix uikit.setup`.

## Sortable Hook

Enables drag-and-drop reordering with server-side sync.

### Setup

```heex
<.uk_sortable id="my-list" phx-hook="Sortable" data-event="reorder_items">
  <div :for={item <- @items} id={"item-#{item.id}"} class="uk-card uk-card-default uk-card-body">
    {item.name}
  </div>
</.uk_sortable>
```

### Event

When items are reordered, the hook pushes an event to the server with the new order of element IDs.

- **Default event name:** `"uikit:reorder"`
- **Custom event name:** Set `data-event` on the container
- **Payload:** `%{"items" => ["item-3", "item-1", "item-2"]}`

### Server handler

```elixir
def handle_event("reorder_items", %{"items" => ids}, socket) do
  # ids is a list of DOM element IDs in the new order
  # Extract your record IDs and update positions
  {:noreply, socket}
end
```

### Requirements

- The container **must** have an `id` and `phx-hook="Sortable"`.
- **Every child element must have a unique `id`** — otherwise LiveView cannot track reordered items.

---

## Modal Hook

Enables server-controlled modal show/hide via assigns.

### Setup

The hook is automatically attached when you use `show` on `uk_modal`:

```heex
<.uk_modal id="my-modal" show={@show_modal} on_close="modal_closed">
  <:header><.uk_modal_title>Title</.uk_modal_title></:header>
  <:body><p>Content</p></:body>
</.uk_modal>
```

### How it works

- Set `show={true}` to open the modal, `show={false}` to close it.
- When the user dismisses the modal (Esc key or background click), the hook pushes the `on_close` event (default: `"uikit:modal_closed"`) so you can sync state.
- **Payload:** `%{"id" => "my-modal"}`

### Server handler

```elixir
def handle_event("modal_closed", %{"id" => _id}, socket) do
  {:noreply, assign(socket, show_modal: false)}
end
```

### Client-side only alternative

If you don't need server control, skip `show` and use `uk_toggle` on a button:

```heex
<.uk_button uk_toggle="target: #my-modal">Open</.uk_button>
<.uk_modal id="my-modal">
  <:body>Content</:body>
</.uk_modal>
```

---

## Icon Hook

Allows UIkit icons to update dynamically when server assigns change. UIkit replaces icon elements with inline SVG — without the hook, `phx-update="ignore"` was needed, which prevented any server-driven icon changes.

### How it works

The hook is automatically attached by the `uk_icon` component. On `mounted()` and `updated()`, it calls `UIkit.icon()` to (re-)render the SVG from the current `uk-icon` attribute.

### Requirements

- The `uk_icon` component requires a stable `id` (needed for the hook).

---

## Dropdown Hook

Preserves dropdown open state across LiveView DOM patches. Without this hook, LiveView's morphdom strips UIkit's `uk-open` class on every server update, causing open dropdowns to close unexpectedly.

### How it works

The hook is automatically attached by the `uk_dropdown` component — no manual setup needed. Before each LiveView patch, it records whether the dropdown is open. After the patch, it restores the open state if it was active.

### Requirements

- The `uk_dropdown` component requires a stable `id` (needed for the hook).
- The `uk-drop uk-dropdown` classes are pre-declared in the server HTML to prevent morphdom from stripping UIkit's positioning styles.

---

## Switcher Hook

Enables server-controlled tab switching via assigns.

### Setup

The hook is automatically attached when you use `active` on `uk_subnav`:

```heex
<.uk_subnav id="my-tabs" pill switcher="connect: #my-content" active={@active_tab} on_change="tab_changed">
  <:item href="#">Tab 1</:item>
  <:item href="#">Tab 2</:item>
  <:item href="#">Tab 3</:item>
</.uk_subnav>

<.uk_switcher id="my-content">
  <li>Content 1</li>
  <li>Content 2</li>
  <li>Content 3</li>
</.uk_switcher>
```

### How it works

- Set `active={0}`, `active={1}`, etc. to programmatically switch tabs.
- When the user clicks a tab, the hook pushes the `on_change` event (default: `"uikit:switcher_changed"`) with the new index.
- **Payload:** `%{"id" => "my-tabs", "index" => 1}`

### Server handler

```elixir
def handle_event("tab_changed", %{"index" => index}, socket) do
  {:noreply, assign(socket, active_tab: index)}
end
```

### Client-side only alternative

If you don't need server-side tab state, omit `active` and `on_change`:

```heex
<.uk_subnav id="tabs" pill switcher="connect: #content">
  <:item href="#">Tab 1</:item>
  <:item href="#">Tab 2</:item>
</.uk_subnav>

<.uk_switcher id="content">
  <li>Content 1</li>
  <li>Content 2</li>
</.uk_switcher>
```

