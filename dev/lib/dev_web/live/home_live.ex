defmodule DevWeb.HomeLive do
  use DevWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, items: [], show_programmatic_modal: false)}
  end

  def render(assigns) do
    ~H"""
    <.uk_container class="uk-margin-top">
      <h1 class="uk-heading-medium">UIkit Components</h1>
      <p class="uk-text-lead">A collection of UIkit components for Phoenix.</p>

      <.uk_grid gap="large" match class="uk-child-width-1-2@m">
        <div class="uk-width-1-1">
          <.uk_card variant="primary">
            <:header>
              <.uk_card_title>Programmatic Control Test</.uk_card_title>
            </:header>
            <:body>
              <p>Trigger a modal from the server by changing an assign.</p>
              <.uk_button phx-click="open_programmatic_modal" variant="secondary">
                Open via Assign (Server-side)
              </.uk_button>

              <.uk_modal
                id="programmatic-modal"
                show={@show_programmatic_modal}
                on_close="close_programmatic_modal"
              >
                <:header>
                  <.uk_modal_title>Server-side Modal</.uk_modal_title>
                </:header>
                <:body>
                  <p>
                    This modal was opened by setting <code>@show_programmatic_modal</code>
                    to <code>true</code>.
                  </p>
                </:body>
                <:footer class="uk-text-right">
                  <.uk_button phx-click="close_programmatic_modal" variant="primary">
                    Close via Assign
                  </.uk_button>
                </:footer>
              </.uk_modal>
            </:body>
          </.uk_card>
        </div>

        <div class="uk-width-1-1">
          <.uk_card variant="default">
            <:header>
              <.uk_card_title>Dynamic Content Test</.uk_card_title>
            </:header>
            <:body>
              <p>
                Click the button to add an element with an icon. This tests if UIkit picks up new SVG icons automatically.
              </p>
              <.uk_button phx-click="add_item" variant="secondary">
                Add Item with Icon
              </.uk_button>

              <div class="uk-margin-top">
                <.uk_grid gap="small" class="uk-child-width-1-4@s">
                  <div :for={item <- @items}>
                    <div class="uk-card uk-card-default uk-card-body uk-padding-small uk-text-center">
                      <.uk_icon name={item.icon} class="uk-margin-small-right" />
                      {item.label}
                    </div>
                  </div>
                </.uk_grid>
              </div>
            </:body>
          </.uk_card>
        </div>

        <div>
          <.uk_card hover>
            <:header>
              <.uk_card_title>Button</.uk_card_title>
            </:header>
            <:body>
              <div class="space-x-2">
                <.uk_button variant="primary">Primary</.uk_button>
                <.uk_button>Default</.uk_button>
                <.uk_button variant="danger" href="#">Link Button</.uk_button>
                <.uk_button variant="text">Text</.uk_button>
              </div>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/button"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
            </:footer>
          </.uk_card>
        </div>

        <div>
          <.uk_card hover>
            <:header>
              <.uk_card_title>Badge</.uk_card_title>
            </:header>
            <:body>
              <div class="space-x-2">
                <.uk_badge>1</.uk_badge>
                <.uk_badge class="uk-label-success">100</.uk_badge>
                <.uk_badge>New</.uk_badge>
              </div>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/badge"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
            </:footer>
          </.uk_card>
        </div>

        <div>
          <.uk_card hover>
            <:header>
              <.uk_card_title>Card</.uk_card_title>
            </:header>
            <:body>
              <p>
                This is a card component example. It supports headers, bodies, footers, and various modifiers.
              </p>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/card"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
            </:footer>
          </.uk_card>
        </div>

        <div>
          <.uk_card hover>
            <:header>
              <.uk_card_title>Container</.uk_card_title>
            </:header>
            <:body>
              <div class="space-y-2 border p-2 bg-gray-50">
                <.uk_container size="xsmall" class="bg-white border p-1 text-xs">
                  xSmall
                </.uk_container>
                <.uk_container size="small" class="bg-white border p-1 text-xs">Small</.uk_container>
                <.uk_container class="bg-white border p-1 text-xs">Default</.uk_container>
              </div>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/container"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
            </:footer>
          </.uk_card>
        </div>

        <div class="uk-width-1-1">
          <.uk_card hover>
            <:header>
              <.uk_card_title>Grid</.uk_card_title>
            </:header>
            <:body>
              <.uk_grid gap="small" class="uk-child-width-1-3@s uk-text-center" divider>
                <div>
                  <div class="uk-card uk-card-default uk-card-body uk-padding-small">Item 1</div>
                </div>
                <div>
                  <div class="uk-card uk-card-default uk-card-body uk-padding-small">Item 2</div>
                </div>
                <div>
                  <div class="uk-card uk-card-default uk-card-body uk-padding-small">Item 3</div>
                </div>
              </.uk_grid>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/grid"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
            </:footer>
          </.uk_card>
        </div>

        <div>
          <.uk_card hover>
            <:header>
              <.uk_card_title>Sortable</.uk_card_title>
            </:header>
            <:body>
              <.uk_sortable
                id="home-sortable"
                group="sortable-group"
                class="uk-grid-small uk-child-width-1-3 uk-text-center"
                grid
              >
                <div>
                  <div class="uk-card uk-card-default uk-card-body uk-padding-small">Item 1</div>
                </div>
                <div>
                  <div class="uk-card uk-card-default uk-card-body uk-padding-small">Item 2</div>
                </div>
                <div>
                  <div class="uk-card uk-card-default uk-card-body uk-padding-small">Item 3</div>
                </div>
              </.uk_sortable>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/sortable"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
              <.uk_button href="/sortable" variant="text">Live Demo</.uk_button>
            </:footer>
          </.uk_card>
        </div>

        <div>
          <.uk_card hover>
            <:header>
              <.uk_card_title>Icon</.uk_card_title>
            </:header>
            <:body>
              <div class="uk-flex uk-flex-middle space-x-4">
                <.uk_icon name="check" />
                <.uk_icon name="heart" ratio={2} class="uk-text-danger" />
                <.uk_icon name="trash" button href="#" />
                <.uk_icon name="twitter" href="#" />
                <.uk_icon name="home" ratio={1.5} />
              </div>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/icon"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
            </:footer>
          </.uk_card>
        </div>

        <div>
          <.uk_card hover>
            <:header>
              <.uk_card_title>Modal</.uk_card_title>
            </:header>
            <:body>
              <p>Modals are used for dialogs and focused interactions.</p>
              <div class="space-x-2">
                <.uk_button variant="primary" uk_toggle="target: #modal-example">
                  Open Modal
                </.uk_button>
                <.uk_button variant="secondary" uk_toggle="target: #modal-center">
                  Open Centered
                </.uk_button>
              </div>

              <.uk_modal id="modal-example">
                <:header>
                  <.uk_modal_title>Example Modal</.uk_modal_title>
                </:header>
                <:body>
                  <p>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                  </p>
                </:body>
                <:footer class="uk-text-right">
                  <.uk_button class="uk-modal-close">Cancel</.uk_button>
                  <.uk_button variant="primary">Save</.uk_button>
                </:footer>
              </.uk_modal>

              <.uk_modal id="modal-center" center>
                <:header>
                  <.uk_modal_title>Centered Modal</.uk_modal_title>
                </:header>
                <:body>
                  <p>This modal is vertically centered.</p>
                </:body>
              </.uk_modal>
            </:body>
            <:footer>
              <a
                href="https://getuikit.com/docs/modal"
                target="_blank"
                class="uk-button uk-button-text"
              >
                Documentation
              </a>
            </:footer>
          </.uk_card>
        </div>
      </.uk_grid>
    </.uk_container>
    """
  end

  def handle_event("add_item", _params, socket) do
    icons = ~w(star bolt cloud bell heart check info warning user mail)

    new_item = %{
      id: System.unique_integer([:positive]),
      icon: Enum.random(icons),
      label: "Item #{length(socket.assigns.items) + 1}"
    }

    {:noreply, assign(socket, items: [new_item | socket.assigns.items])}
  end

  def handle_event("open_programmatic_modal", _params, socket) do
    {:noreply, assign(socket, show_programmatic_modal: true)}
  end

  def handle_event("close_programmatic_modal", _params, socket) do
    {:noreply, assign(socket, show_programmatic_modal: false)}
  end

  def handle_event("uikit:modal_closed", %{"id" => "programmatic-modal"}, socket) do
    {:noreply, assign(socket, show_programmatic_modal: false)}
  end

  def handle_event("uikit:modal_closed", _params, socket) do
    {:noreply, socket}
  end
end
