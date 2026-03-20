defmodule DevWeb.HomeLive do
  use DevWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    {:ok,
     assign(socket,
       items: [],
       show_programmatic_modal: false,
       loading: false,
       switcher_index: 0,
       counter: 0
     )}
  end

  def render(assigns) do
    ~H"""
    <.uk_section variant="default">
      <.uk_container>
        <.uk_grid divider class="uk-grid-divider">
          <%!-- Sidebar --%>
          <div class="uk-width-1-4@m">
            <ul class="uk-nav uk-nav-default" uk-scrollspy-nav="closest: li; scroll: true; offset: 40">
              <li class="uk-nav-header">Getting Started</li>
              <li><a href="#introduction">Introduction</a></li>
              <li class="uk-nav-divider"></li>
              <li class="uk-nav-header">Components</li>
              <li><a href="#button">Button</a></li>
              <li><a href="#badge">Badge</a></li>
              <li><a href="#label">Label</a></li>
              <li><a href="#card">Card</a></li>
              <li><a href="#container">Container</a></li>
              <li><a href="#grid">Grid</a></li>
              <li><a href="#icon">Icon</a></li>
              <li><a href="#modal">Modal</a></li>
              <li><a href="#sortable">Sortable</a></li>
              <li><a href="#spinner">Spinner</a></li>
              <li><a href="#subnav">Subnav</a></li>
              <li><a href="#switcher">Switcher</a></li>
              <li><a href="#dropdown">Dropdown</a></li>
              <li><a href="#comment">Comment</a></li>
              <li class="uk-nav-divider"></li>
              <li class="uk-nav-header">Other Pages</li>
              <li><.link navigate="/forms">Form Components</.link></li>
              <li><.link navigate="/sortable">Sortable</.link></li>
              <li class="uk-nav-divider"></li>
              <li class="uk-nav-header">Interactive Tests</li>
              <li><a href="#dynamic-content">Dynamic Content</a></li>
              <li><a href="#programmatic-modal">Programmatic Modal</a></li>
              <li><a href="#async-loading">Async Loading</a></li>
              <li><a href="#programmatic-switcher">Programmatic Switcher</a></li>
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
              <.uk_card>
                <:body>
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
                </:body>
              </.uk_card>
            </section>

            <section id="badge" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Badge</h2>
              <.uk_card>
                <:body>
                  <div class="uk-flex gap-2">
                    <.uk_badge>1</.uk_badge>
                    <.uk_badge class="uk-label-success">Success</.uk_badge>
                    <.uk_badge class="uk-label-warning">Warning</.uk_badge>
                    <.uk_badge class="uk-label-danger">Danger</.uk_badge>
                  </div>
                </:body>
              </.uk_card>
            </section>

            <section id="label" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Label</h2>
              <.uk_card>
                <:body>
                  <div class="uk-flex gap-2">
                    <.uk_label>Default</.uk_label>
                    <.uk_label variant="success">Success</.uk_label>
                    <.uk_label variant="warning">Warning</.uk_label>
                    <.uk_label variant="danger">Danger</.uk_label>
                  </div>
                </:body>
              </.uk_card>
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
              <.uk_card>
                <:body>
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
                </:body>
              </.uk_card>
            </section>

            <section id="grid" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Grid</h2>
              <.uk_card>
                <:body>
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
                </:body>
              </.uk_card>
            </section>

            <section id="icon" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Icon</h2>
              <.uk_card>
                <:body>
                  <div class="uk-flex uk-flex-middle gap-4">
                    <.uk_icon name="check" ratio={1.5} />
                    <.uk_icon name="heart" class="uk-text-danger" ratio={1.5} />
                    <.uk_icon name="trash" button href="#" />
                    <.uk_icon name="twitter" href="#" />
                    <.uk_icon name="home" ratio={2} />
                  </div>
                </:body>
              </.uk_card>
            </section>

            <section id="modal" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Modal</h2>
              <.uk_card>
                <:body>
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
                </:body>
              </.uk_card>
            </section>

            <section id="sortable" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Sortable</h2>
              <.uk_card>
                <:body>
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
                </:body>
              </.uk_card>
            </section>

            <section id="spinner" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Spinner</h2>
              <.uk_card>
                <:body>
                  <div class="uk-flex uk-flex-middle gap-4">
                    <.uk_spinner />
                    <.uk_spinner ratio={2} />
                    <.uk_spinner ratio={3} />
                  </div>
                </:body>
              </.uk_card>
            </section>

            <section id="subnav" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Subnav</h2>
              <.uk_card>
                <:body>
                  <h3 class="uk-h4">Default</h3>
                  <.uk_subnav id="subnav-default-demo">
                    <:item href="#subnav-1" active>Active</:item>
                    <:item href="#subnav-2">Item</:item>
                    <:item href="#subnav-3">Item</:item>
                    <:item disabled>Disabled</:item>
                  </.uk_subnav>

                  <h3 class="uk-h4 uk-margin-top">Divider</h3>
                  <.uk_subnav id="subnav-divider-demo" divider>
                    <:item href="#divider-1" active>Active</:item>
                    <:item href="#divider-2">Item</:item>
                    <:item href="#divider-3">Item</:item>
                  </.uk_subnav>

                  <h3 class="uk-h4 uk-margin-top">Pill</h3>
                  <.uk_subnav id="subnav-pill-demo" pill>
                    <:item href="#pill-1" active>Active</:item>
                    <:item href="#pill-2">Item</:item>
                    <:item href="#pill-3">Item</:item>
                  </.uk_subnav>
                </:body>
              </.uk_card>
            </section>

            <section id="switcher" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Switcher</h2>
              <.uk_card>
                <:body>
                  <.uk_subnav id="nav-switcher-demo" pill switcher="connect: #switcher-demo">
                    <:item href="#">Item 1</:item>
                    <:item href="#">Item 2</:item>
                    <:item href="#">Item 3</:item>
                  </.uk_subnav>

                  <.uk_switcher id="switcher-demo" class="uk-margin">
                    <li>
                      <div class="uk-alert uk-alert-primary">Content 1: Hello!</div>
                    </li>
                    <li>
                      <div class="uk-alert uk-alert-success">Content 2: Welcome back!</div>
                    </li>
                    <li>
                      <div class="uk-alert uk-alert-warning">Content 3: Goodbye!</div>
                    </li>
                  </.uk_switcher>
                </:body>
              </.uk_card>
            </section>

            <section id="dropdown" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Dropdown</h2>
              <.uk_card>
                <:body>
                  <p class="uk-text-meta uk-margin-small-bottom">
                    Server counter: <strong>{@counter}</strong>
                    — updates every second. Open a dropdown to see it update inside.
                  </p>
                  <h3 class="uk-h4">Hover (default)</h3>
                  <div class="uk-flex gap-2 uk-flex-wrap">
                    <div class="uk-inline">
                      <.uk_button>Hover</.uk_button>
                      <.uk_dropdown id="dd-hover">
                        <p>
                          Counter: <strong>{@counter}</strong>
                        </p>
                        <p class="uk-text-meta">
                          This value updates every second via LiveView, even while the dropdown is open.
                        </p>
                      </.uk_dropdown>
                    </div>

                    <div class="uk-inline">
                      <.uk_button variant="primary">Click Toggle</.uk_button>
                      <.uk_dropdown id="dd-click" mode="click">
                        <p>Counter: <strong>{@counter}</strong></p>
                        <p class="uk-text-meta">Click-triggered dropdown with live counter.</p>
                      </.uk_dropdown>
                    </div>

                    <div class="uk-inline">
                      <.uk_button variant="secondary">Large</.uk_button>
                      <.uk_dropdown id="dd-large" large>
                        <p>Counter: <strong>{@counter}</strong></p>
                        <p class="uk-text-meta">Large dropdown with live counter.</p>
                      </.uk_dropdown>
                    </div>
                  </div>

                  <h3 class="uk-h4 uk-margin-top">Navigation</h3>
                  <div class="uk-flex gap-2 uk-flex-wrap">
                    <div class="uk-inline">
                      <.uk_button>Nav Dropdown</.uk_button>
                      <.uk_dropdown id="dd-nav">
                        <:nav>
                          <li class="uk-active"><a href="#">Active</a></li>
                          <li><a href="#">Item</a></li>
                          <li class="uk-nav-header">Header</li>
                          <li><a href="#">Item</a></li>
                          <li><a href="#">Item</a></li>
                          <li class="uk-nav-divider"></li>
                          <li><a href="#">Item</a></li>
                        </:nav>
                      </.uk_dropdown>
                    </div>

                    <div class="uk-inline">
                      <.uk_button variant="primary">Click Nav</.uk_button>
                      <.uk_dropdown id="dd-click-nav" mode="click">
                        <:nav>
                          <li><a href="#">Dashboard</a></li>
                          <li><a href="#">Settings</a></li>
                          <li class="uk-nav-divider"></li>
                          <li><a href="#">Logout</a></li>
                        </:nav>
                      </.uk_dropdown>
                    </div>
                  </div>

                  <h3 class="uk-h4 uk-margin-top">Positioning</h3>
                  <div class="uk-flex gap-2 uk-flex-wrap">
                    <div class="uk-inline">
                      <.uk_button>Top Center</.uk_button>
                      <.uk_dropdown id="dd-top-center" pos="top-center">
                        <p>Positioned top-center.</p>
                      </.uk_dropdown>
                    </div>

                    <div class="uk-inline">
                      <.uk_button>Bottom Right</.uk_button>
                      <.uk_dropdown id="dd-bottom-right" pos="bottom-right">
                        <p>Positioned bottom-right.</p>
                      </.uk_dropdown>
                    </div>

                    <div class="uk-inline">
                      <.uk_button>Right Top</.uk_button>
                      <.uk_dropdown id="dd-right-top" pos="right-top">
                        <p>Positioned right-top.</p>
                      </.uk_dropdown>
                    </div>
                  </div>

                  <h3 class="uk-h4 uk-margin-top">Animation</h3>
                  <div class="uk-flex gap-2 uk-flex-wrap">
                    <div class="uk-inline">
                      <.uk_button>Slide Top</.uk_button>
                      <.uk_dropdown id="dd-slide-top" animation="slide-top" animate_out duration={700}>
                        <p>Animated with slide-top.</p>
                      </.uk_dropdown>
                    </div>

                    <div class="uk-inline">
                      <.uk_button>Reveal Top</.uk_button>
                      <.uk_dropdown id="dd-reveal-top" animation="reveal-top" animate_out duration={500}>
                        <p>Animated with reveal-top.</p>
                      </.uk_dropdown>
                    </div>
                  </div>
                </:body>
              </.uk_card>
            </section>

            <section id="comment" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom">Comment</h2>
              <.uk_card>
                <:body>
                  <h3 class="uk-h4">Single Comment</h3>
                  <.uk_comment id="demo-comment-single">
                    <:avatar
                      src="https://getuikit.com/docs/images/avatar.jpg"
                      width="80"
                      height="80"
                      alt="Avatar"
                    />
                    <:title>Author</:title>
                    <:meta>12 days ago</:meta>
                    <:meta><a href="#">Reply</a></:meta>
                    <:body>
                      <p>
                        Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
                        nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.
                      </p>
                    </:body>
                  </.uk_comment>

                  <h3 class="uk-h4 uk-margin-top">Primary Comment</h3>
                  <.uk_comment id="demo-comment-primary" primary>
                    <:avatar
                      src="https://getuikit.com/docs/images/avatar.jpg"
                      width="80"
                      height="80"
                      alt="Avatar"
                    />
                    <:title>Admin</:title>
                    <:meta>5 minutes ago</:meta>
                    <:body>
                      <p>
                        This is a highlighted comment, useful for admin or featured responses.
                      </p>
                    </:body>
                  </.uk_comment>

                  <h3 class="uk-h4 uk-margin-top">Threaded Comment List</h3>
                  <.uk_comment_list>
                    <li>
                      <.uk_comment id="demo-thread-1">
                        <:avatar
                          src="https://getuikit.com/docs/images/avatar.jpg"
                          width="80"
                          height="80"
                          alt="Avatar"
                        />
                        <:title>Author</:title>
                        <:meta>12 days ago</:meta>
                        <:meta><a href="#">Reply</a></:meta>
                        <:body>
                          <p>
                            Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
                            nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam.
                          </p>
                        </:body>
                      </.uk_comment>
                      <ul>
                        <li>
                          <.uk_comment id="demo-thread-1-1">
                            <:avatar
                              src="https://getuikit.com/docs/images/avatar.jpg"
                              width="80"
                              height="80"
                              alt="Avatar"
                            />
                            <:title>Author</:title>
                            <:meta>6 days ago</:meta>
                            <:meta><a href="#">Reply</a></:meta>
                            <:body>
                              <p>
                                Sed diam voluptua. At vero eos et accusam et justo duo dolores
                                et ea rebum.
                              </p>
                            </:body>
                          </.uk_comment>
                          <ul>
                            <li>
                              <.uk_comment id="demo-thread-1-1-1" primary>
                                <:avatar
                                  src="https://getuikit.com/docs/images/avatar.jpg"
                                  width="80"
                                  height="80"
                                  alt="Avatar"
                                />
                                <:title>Admin</:title>
                                <:meta>3 days ago</:meta>
                                <:body>
                                  <p>Thanks for the feedback! We'll look into this.</p>
                                </:body>
                              </.uk_comment>
                            </li>
                          </ul>
                        </li>
                      </ul>
                    </li>
                    <li>
                      <.uk_comment id="demo-thread-2">
                        <:avatar
                          src="https://getuikit.com/docs/images/avatar.jpg"
                          width="80"
                          height="80"
                          alt="Avatar"
                        />
                        <:title>Author</:title>
                        <:meta>4 days ago</:meta>
                        <:meta><a href="#">Reply</a></:meta>
                        <:body>
                          <p>
                            Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum
                            dolor sit amet.
                          </p>
                        </:body>
                      </.uk_comment>
                    </li>
                  </.uk_comment_list>
                </:body>
              </.uk_card>
            </section>

            <hr class="uk-divider-icon" />

            <section id="dynamic-content" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom uk-text-primary">
                Interactive: Dynamic Content
              </h2>
              <.uk_card>
                <:body>
                  <p>Tests if UIkit picks up new components added by LiveView.</p>
                  <.uk_button phx-click="add_item" variant="primary">
                    Add Item with Random Icon
                  </.uk_button>

                  <div class="uk-margin-top">
                    <.uk_grid gap="small" class="uk-child-width-1-4@s">
                      <div :for={item <- @items}>
                        <.uk_card size="small" class="uk-text-center">
                          <:body>
                            <.uk_icon name={item.icon} class="uk-margin-small-right" />
                            {item.label}
                          </:body>
                        </.uk_card>
                      </div>
                    </.uk_grid>
                  </div>
                </:body>
              </.uk_card>
            </section>

            <section id="async-loading" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom uk-text-primary">Interactive: Async Loading</h2>
              <.uk_card>
                <:body>
                  <p>Simulate a server-side loading state using a spinner controlled by an assign.</p>
                  <.uk_button phx-click="start_loading" variant="primary" disabled={@loading}>
                    {if @loading, do: "Loading...", else: "Start Async Task"}
                  </.uk_button>

                  <div class="uk-margin-top uk-height-small uk-flex uk-flex-center uk-flex-middle border">
                    <%= if @loading do %>
                      <div class="uk-text-center">
                        <.uk_spinner ratio={1.5} />
                        <div class="uk-text-meta uk-margin-small-top">Processing on server...</div>
                      </div>
                    <% else %>
                      <div class="uk-text-muted">Task results will appear here.</div>
                    <% end %>
                  </div>
                </:body>
              </.uk_card>
            </section>

            <section id="programmatic-switcher" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom uk-text-primary">
                Interactive: Programmatic Switcher
              </h2>
              <.uk_card>
                <:body>
                  <p>Change the active pane of a switcher from the server.</p>
                  <div class="uk-margin-bottom uk-flex gap-2">
                    <.uk_button phx-click="set_switcher" phx-value-index="0" variant="secondary">
                      Show Pane 1
                    </.uk_button>
                    <.uk_button phx-click="set_switcher" phx-value-index="1" variant="secondary">
                      Show Pane 2
                    </.uk_button>
                    <.uk_button phx-click="set_switcher" phx-value-index="2" variant="secondary">
                      Show Pane 3
                    </.uk_button>
                  </div>

                  <.uk_subnav
                    id="prog-switcher-nav"
                    pill
                    switcher="connect: #prog-switcher"
                    active={@switcher_index}
                  >
                    <:item href="#" active={@switcher_index == 0} id="prog-pane-0">Pane 1</:item>
                    <:item href="#" active={@switcher_index == 1} id="prog-pane-1">Pane 2</:item>
                    <:item href="#" active={@switcher_index == 2} id="prog-pane-2">Pane 3</:item>
                  </.uk_subnav>

                  <.uk_switcher id="prog-switcher" class="uk-margin">
                    <li>
                      <div class="uk-alert uk-alert-primary">Content 1</div>
                    </li>
                    <li>
                      <div class="uk-alert uk-alert-success">Content 2</div>
                    </li>
                    <li>
                      <div class="uk-alert uk-alert-warning">Content 3</div>
                    </li>
                  </.uk_switcher>
                </:body>
              </.uk_card>
            </section>

            <section id="programmatic-modal" class="uk-margin-large-bottom">
              <h2 class="uk-h2 uk-margin-small-bottom uk-text-primary">
                Interactive: Programmatic Modal
              </h2>
              <.uk_card>
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
        </.uk_grid>
      </.uk_container>
    </.uk_section>
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

  def handle_event("set_switcher", %{"index" => index}, socket) do
    {:noreply, assign(socket, switcher_index: String.to_integer(index))}
  end

  def handle_event("uikit:switcher_changed", %{"index" => index}, socket) do
    {:noreply, assign(socket, switcher_index: index)}
  end

  def handle_event("start_loading", _params, socket) do
    Process.send_after(self(), :finished_loading, 2000)
    {:noreply, assign(socket, loading: true)}
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

  def handle_info(:tick, socket) do
    {:noreply, assign(socket, counter: socket.assigns.counter + 1)}
  end

  def handle_info(:finished_loading, socket) do
    {:noreply, assign(socket, loading: false)}
  end
end
