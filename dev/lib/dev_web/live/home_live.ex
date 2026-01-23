defmodule DevWeb.HomeLive do
  use DevWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, items: [], show_programmatic_modal: false)}
  end

  def render(assigns) do
    ~H"""
    <div class="uk-section uk-section-default">
      <div class="uk-container">
        <div class="uk-grid uk-grid-divider" uk-grid>
          <%!-- Sidebar --%>
          <div class="uk-width-1-4@m">
            <ul class="uk-nav uk-nav-default" uk-scrollspy-nav="closest: li; scroll: true; offset: 40">
              <li class="uk-nav-header">Getting Started</li>
              <li><a href="#introduction">Introduction</a></li>
              <li class="uk-nav-divider"></li>
              <li class="uk-nav-header">Components</li>
              <li><a href="#button">Button</a></li>
              <li><a href="#badge">Badge</a></li>
              <li><a href="#card">Card</a></li>
              <li><a href="#container">Container</a></li>
              <li><a href="#grid">Grid</a></li>
              <li><a href="#icon">Icon</a></li>
              <li><a href="#modal">Modal</a></li>
              <li><a href="#sortable">Sortable</a></li>
              <li class="uk-nav-divider"></li>
              <li class="uk-nav-header">Interactive Tests</li>
              <li><a href="#dynamic-content">Dynamic Content</a></li>
              <li><a href="#programmatic-modal">Programmatic Modal</a></li>
            </ul>
          </div>

          <%!-- Content --%>
          <div id="content-body" class="uk-width-3-4@m">
            <div id="introduction" class="uk-margin-large-bottom">
              <h1 class="uk-heading-medium">Elixir Uikit</h1>
              <p class="uk-text-lead">
                A Phoenix component library for the
                <a href="https://getuikit.com" target="_blank">UIkit</a>
                CSS framework.
              </p>
              <p>
                This workbench allows you to test and develop components in a live environment.
              </p>
            </div>

            <section id="button" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Button</h2>
              <div class="uk-card uk-card-default uk-card-body">
                <div class="uk-flex uk-flex-wrap gap-2">
                  <.uk_button variant="primary">Primary</.uk_button>
                  <.uk_button>Default</.uk_button>
                  <.uk_button variant="secondary">Secondary</.uk_button>
                  <.uk_button variant="danger">Danger</.uk_button>
                  <.uk_button variant="text">Text</.uk_button>
                  <.uk_button variant="link">Link</.uk_button>
                </div>
                <div class="uk-margin-top">
                  <.uk_button variant="primary" size="small">Small</.uk_button>
                  <.uk_button variant="primary">Default</.uk_button>
                  <.uk_button variant="primary" size="large">Large</.uk_button>
                </div>
              </div>
            </section>

            <section id="badge" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Badge</h2>
              <div class="uk-card uk-card-default uk-card-body">
                <div class="uk-flex gap-2">
                  <.uk_badge>1</.uk_badge>
                  <.uk_badge class="uk-label-success">Success</.uk_badge>
                  <.uk_badge class="uk-label-warning">Warning</.uk_badge>
                  <.uk_badge class="uk-label-danger">Danger</.uk_badge>
                </div>
              </div>
            </section>

            <section id="card" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Card</h2>
              <.uk_grid match class="uk-child-width-1-3@s">
                <div>
                  <.uk_card>
                    <:header>
                      <.uk_card_title>Default</.uk_card_title>
                    </:header>
                    <:body>
                      <p>Standard card style.</p>
                    </:body>
                  </.uk_card>
                </div>
                <div>
                  <.uk_card variant="primary">
                    <:header>
                      <.uk_card_title>Primary</.uk_card_title>
                    </:header>
                    <:body>
                      <p>Emphasized style.</p>
                    </:body>
                  </.uk_card>
                </div>
                <div>
                  <.uk_card variant="secondary" hover>
                    <:header>
                      <.uk_card_title>Secondary + Hover</.uk_card_title>
                    </:header>
                    <:body>
                      <p>Alternative style with hover effect.</p>
                    </:body>
                  </.uk_card>
                </div>
              </.uk_grid>
            </section>

            <section id="container" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Container</h2>
              <div class="uk-card uk-card-default uk-card-body">
                <div class="space-y-4">
                  <div class="bg-gray-100 p-2 text-center text-xs">
                    <.uk_container size="xsmall" class="bg-white border">
                      xSmall Container
                    </.uk_container>
                  </div>
                  <div class="bg-gray-100 p-2 text-center text-xs">
                    <.uk_container size="small" class="bg-white border">
                      Small Container
                    </.uk_container>
                  </div>
                  <div class="bg-gray-100 p-2 text-center text-xs">
                    <.uk_container class="bg-white border">Default Container</.uk_container>
                  </div>
                </div>
              </div>
            </section>

            <section id="grid" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Grid</h2>
              <div class="uk-card uk-card-default uk-card-body">
                <.uk_grid divider class="uk-child-width-1-3@s uk-text-center">
                  <div>Item 1</div>
                  <div>Item 2</div>
                  <div>Item 3</div>
                </.uk_grid>
                <div class="uk-margin-medium-top">
                  <.uk_grid gap="small" class="uk-child-width-1-4@s uk-text-center">
                    <div class="bg-gray-100 p-2">Small Gap</div>
                    <div class="bg-gray-100 p-2">Small Gap</div>
                    <div class="bg-gray-100 p-2">Small Gap</div>
                    <div class="bg-gray-100 p-2">Small Gap</div>
                  </.uk_grid>
                </div>
              </div>
            </section>

            <section id="icon" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Icon</h2>
              <div class="uk-card uk-card-default uk-card-body">
                <div class="uk-flex uk-flex-middle gap-4">
                  <.uk_icon name="check" ratio={1.5} />
                  <.uk_icon name="heart" class="uk-text-danger" ratio={1.5} />
                  <.uk_icon name="trash" button href="#" />
                  <.uk_icon name="twitter" href="#" />
                  <.uk_icon name="home" ratio={2} />
                </div>
              </div>
            </section>

            <section id="modal" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Modal</h2>
              <div class="uk-card uk-card-default uk-card-body">
                <div class="uk-flex gap-2">
                  <.uk_button variant="primary" uk_toggle="target: #demo-modal">
                    Basic Modal
                  </.uk_button>
                  <.uk_button variant="secondary" uk_toggle="target: #demo-modal-center">
                    Centered Modal
                  </.uk_button>
                </div>

                <.uk_modal id="demo-modal">
                  <:header>
                    <.uk_modal_title>Basic Modal</.uk_modal_title>
                  </:header>
                  <:body>
                    <p>This is a standard UIkit modal.</p>
                  </:body>
                  <:footer class="uk-text-right">
                    <.uk_button class="uk-modal-close">Close</.uk_button>
                  </:footer>
                </.uk_modal>

                <.uk_modal id="demo-modal-center" center>
                  <:header>
                    <.uk_modal_title>Centered Modal</.uk_modal_title>
                  </:header>
                  <:body>
                    <p>This modal is vertically centered.</p>
                  </:body>
                </.uk_modal>
              </div>
            </section>

            <section id="sortable" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Sortable</h2>
              <div class="uk-card uk-card-default uk-card-body">
                <.uk_sortable id="demo-sortable" group="demo" grid class="uk-child-width-1-3@s">
                  <div>
                    <div class="bg-gray-100 p-4 uk-text-center">1</div>
                  </div>
                  <div>
                    <div class="bg-gray-100 p-4 uk-text-center">2</div>
                  </div>
                  <div>
                    <div class="bg-gray-100 p-4 uk-text-center">3</div>
                  </div>
                </.uk_sortable>
                <div class="uk-margin-top">
                  <.uk_button href="/sortable" variant="link">Detailed LiveView Demo</.uk_button>
                </div>
              </div>
            </section>

            <hr class="uk-divider-icon" />

            <section id="dynamic-content" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom text-primary">Interactive: Dynamic Content</h2>
              <.uk_card variant="default">
                <:body>
                  <p>Tests if UIkit picks up new components added by LiveView.</p>
                  <.uk_button phx-click="add_item" variant="primary">
                    Add Item with Random Icon
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
            </section>

            <section id="programmatic-modal" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom text-primary">
                Interactive: Programmatic Modal
              </h2>
              <.uk_card variant="default">
                <:body>
                  <p>Open a modal by changing a server-side assign.</p>
                  <.uk_button phx-click="open_programmatic_modal" variant="primary">
                    Open from Server
                  </.uk_button>

                  <.uk_modal
                    id="prog-modal"
                    show={@show_programmatic_modal}
                    on_close="close_programmatic_modal"
                  >
                    <:header>
                      <.uk_modal_title>Server Controlled</.uk_modal_title>
                    </:header>
                    <:body>
                      <p>This was triggered by an assign.</p>
                    </:body>
                    <:footer class="uk-text-right">
                      <.uk_button phx-click="close_programmatic_modal" variant="primary">
                        Close
                      </.uk_button>
                    </:footer>
                  </.uk_modal>
                </:body>
              </.uk_card>
            </section>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("add_item", _params, socket) do
    icons = ~w(star bolt cloud bell heart check info warning user mail settings search lock)

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

  def handle_event("uikit:modal_closed", _params, socket) do
    {:noreply, assign(socket, show_programmatic_modal: false)}
  end
end
