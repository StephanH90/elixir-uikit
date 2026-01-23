defmodule DevWeb.SortableLive do
  use DevWeb, :live_view

  def mount(_params, _session, socket) do
    items = [
      %{id: "item-1", text: "Item 1"},
      %{id: "item-2", text: "Item 2"},
      %{id: "item-3", text: "Item 3"}
    ]

    {:ok, assign(socket, items: items)}
  end

  def render(assigns) do
    ~H"""
    <.uk_container class="uk-margin-top">
      <h1>Sortable LiveView Demo</h1>
      <p>Drag and drop items to reorder. Check the console/logs for the new order.</p>

      <.uk_sortable
        id="my-sortable"
        phx-hook="Sortable"
        grid
        class="uk-child-width-1-3@s uk-text-center"
      >
        <div :for={item <- @items} id={item.id}>
          <div class="uk-card uk-card-default uk-card-body">
            {item.text}
          </div>
        </div>
      </.uk_sortable>

      <div class="uk-margin-top">
        <h3>Current Order:</h3>
        <pre>{inspect(@items, pretty: true)}</pre>
      </div>
    </.uk_container>
    """
  end

  def handle_event("uikit:reorder", %{"items" => item_ids}, socket) do
    # Reorder the items list based on the IDs received from the client
    existing_items = socket.assigns.items

    new_items =
      Enum.map(item_ids, fn id ->
        Enum.find(existing_items, &(&1.id == id))
      end)
      |> Enum.reject(&is_nil/1)

    {:noreply, assign(socket, items: new_items)}
  end
end
