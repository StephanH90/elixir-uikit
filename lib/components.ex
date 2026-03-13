defmodule Uikit.Components do
  @moduledoc """
  Provides UIkit components for Phoenix applications.

  This module offers a collection of function components that wrap standard UIkit elements,
  making them easy to use within Phoenix LiveView and HEEx templates.

  ## Prerequisites

  Ensure that UIkit CSS and JS are loaded in your application.
  See the `README.md` for installation instructions.

  ## Usage

  Import this module in your web interface (e.g., `lib/my_app_web.ex`):

      defp html_helpers do
        quote do
          # ...
          import Uikit.Components
          # ...
        end
      end
  """
  use Phoenix.Component

  @doc """
  Renders a UIkit button.

  Supports standard button styles and can function as a link if `href`, `navigate`, or `patch` attributes are provided.

  ## Examples

      <.uk_button>Default</.uk_button>
      <.uk_button variant="primary">Primary</.uk_button>
      <.uk_button variant="danger" size="small">Small Danger</.uk_button>
      <.uk_button href="/home">Link Button</.uk_button>
  """
  attr :variant, :string,
    default: "default",
    values: ~w(default primary secondary danger text link),
    doc: "the visual style of the button"

  attr :size, :string,
    default: nil,
    values: [nil, "small", "large"],
    doc: "the size of the button"

  attr :type, :string,
    default: "button",
    doc: "the HTML type of the button (submit, reset, button)"

  attr :uk_toggle, :any, default: nil, doc: "the target modal or toggleable element"
  attr :disabled, :boolean, default: false, doc: "whether the button is disabled"
  attr :class, :any, doc: "additional CSS classes"

  attr :rest, :global,
    include: ~w(href navigate patch method download uk-icon uk-toggle),
    doc: "the arbitrary HTML attributes to add to the button container"

  slot :inner_block, required: true, doc: "the content of the button"

  def uk_button(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn ->
        [
          "uk-button",
          "uk-button-#{assigns.variant}",
          assigns.size && "uk-button-#{assigns.size}"
        ]
      end)
      |> assign(:rest, prepare_button_rest(assigns))

    if assigns.rest[:href] || assigns.rest[:navigate] || assigns.rest[:patch] do
      ~H"""
      <.link class={@class} {@rest}>
        {render_slot(@inner_block)}
      </.link>
      """
    else
      ~H"""
      <button type={@type} class={@class} {@rest}>
        {render_slot(@inner_block)}
      </button>
      """
    end
  end

  defp prepare_button_rest(assigns) do
    rest = assigns.rest

    rest =
      if assigns.uk_toggle do
        Map.put(rest, :"uk-toggle", assigns.uk_toggle)
      else
        rest
      end

    if assigns.disabled do
      Map.put(rest, :disabled, true)
    else
      rest
    end
  end

  @doc """
  Renders a UIkit badge.

  Badges are used to highlight information, such as counts or labels.

  ## Examples

      <.uk_badge>1</.uk_badge>
      <.uk_badge class="uk-label-success">100</.uk_badge>
  """
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the badge container"
  slot :inner_block, required: true, doc: "the content of the badge"

  def uk_badge(assigns) do
    ~H"""
    <span class={["uk-badge", @class]} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a UIkit card.

  Cards are layout boxes with modifiers for style and size. They can contain a header, body, and footer.

  ## Examples

      <.uk_card>
        <:header>
          <.uk_card_title>Title</.uk_card_title>
        </:header>
        <:body>
          Content
        </:body>
        <:footer>
          Footer content
        </:footer>
      </.uk_card>
  """
  attr :variant, :string,
    default: "default",
    values: ~w(default primary secondary),
    doc: "the style variant of the card"

  attr :size, :string,
    default: nil,
    values: [nil, "small", "large"],
    doc: "the padding size of the card"

  attr :hover, :boolean, default: false, doc: "whether to add a hover effect"
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the card container"

  slot :header, doc: "the card header content"
  slot :body, doc: "the card body content"

  slot :footer, doc: "the card footer content" do
    attr :class, :any, doc: "additional CSS classes for the footer"
  end

  slot :close, doc: "custom close button. If not provided, a default one is included"
  slot :inner_block, doc: "inner content, if not using structured slots"

  def uk_card(assigns) do
    ~H"""
    <div
      class={[
        "uk-card",
        "uk-card-#{@variant}",
        @size && "uk-card-#{@size}",
        @hover && "uk-card-hover",
        @class
      ]}
      {@rest}
    >
      <div :if={@header != []} class="uk-card-header">
        {render_slot(@header)}
      </div>

      <div :if={@body != []} class="uk-card-body">
        {render_slot(@body)}
      </div>

      {render_slot(@inner_block)}

      <div :if={@footer != []} class={["uk-card-footer", Enum.at(@footer, 0)[:class]]}>
        {render_slot(@footer)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a title for the card component.
  """
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the title"
  slot :inner_block, required: true, doc: "the title text"

  def uk_card_title(assigns) do
    ~H"""
    <h3 class={["uk-card-title", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  @doc """
  Renders a UIkit container.

  Containers constrain the width of the content and center it.

  ## Examples

      <.uk_container size="small">
        Content
      </.uk_container>
  """
  attr :size, :string,
    default: nil,
    values: [nil, "xsmall", "small", "large", "xlarge", "expand"],
    doc: "the max-width of the container"

  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the container"
  slot :inner_block, required: true, doc: "the container content"

  def uk_container(assigns) do
    ~H"""
    <div
      class={[
        "uk-container",
        @size && "uk-container-#{@size}",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a UIkit section.

  Sections are used to create horizontal layout blocks.

  ## Examples

      <.uk_section variant="primary">
        Content
      </.uk_section>
  """
  attr :variant, :string,
    default: "default",
    values: ~w(default muted primary secondary),
    doc: "the color variant of the section"

  attr :size, :string,
    default: nil,
    values: [nil, "xsmall", "small", "large", "xlarge", "remove-vertical"],
    doc: "the vertical padding size"

  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the section container"
  slot :inner_block, required: true, doc: "the section content"

  def uk_section(assigns) do
    ~H"""
    <div
      class={[
        "uk-section",
        "uk-section-#{@variant}",
        @size && "uk-section-#{@size}",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a UIkit grid.

  The grid component creates a responsive, fluid and nestable grid layout.

  ## Examples

      <.uk_grid gap="small" match>
        <div>Item 1</div>
        <div>Item 2</div>
      </.uk_grid>
  """
  attr :gap, :string,
    default: nil,
    values: [nil, "small", "medium", "large", "collapse"],
    doc: "the grid gap size"

  attr :divider, :boolean, default: false, doc: "whether to show a divider between cells"
  attr :match, :boolean, default: false, doc: "whether to match the height of grid cells"

  attr :masonry, :string,
    default: nil,
    values: [nil, "pack", "next", "true"],
    doc: "enables masonry layout"

  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the grid container"
  slot :inner_block, required: true, doc: "the grid items"

  def uk_grid(assigns) do
    grid_opts =
      if assigns.masonry do
        "masonry: #{assigns.masonry}"
      else
        true
      end

    assigns = assign(assigns, :grid_opts, grid_opts)

    ~H"""
    <div
      uk-grid={@grid_opts}
      class={[
        "uk-grid",
        @gap && "uk-grid-#{@gap}",
        @divider && "uk-grid-divider",
        @match && "uk-grid-match",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a UIkit sortable container.

  Enables drag and drop reordering of items. 

  ### Important: IDs and LiveView
  To ensure reordering works correctly with LiveView:
  1. **Provide an `id`** to the `<.uk_sortable>` container.
  2. **Every child element** inside the sortable container **must have a unique `id`**.
  3. Use the `Sortable` hook for server-side integration.

  ## Examples

      <.uk_sortable id="my-sortable" group="my-group" grid phx-hook="Sortable">
        <div id="item-1">Item 1</div>
        <div id="item-2">Item 2</div>
      </.uk_sortable>
  """
  attr :id, :string, required: true, doc: "the DOM ID of the container (required for hooks)"
  attr :group, :string, default: nil, doc: "the group name for dragging between lists"
  attr :animation, :integer, default: nil, doc: "animation duration in milliseconds"
  attr :threshold, :integer, default: nil, doc: "mouse move threshold before dragging starts"
  attr :handle, :string, default: nil, doc: "selector for the drag handle"
  attr :cls_custom, :string, default: nil, doc: "custom class for the dragged item"
  attr :grid, :boolean, default: false, doc: "whether to apply the grid component behavior"
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the sortable container"
  slot :inner_block, required: true, doc: "the sortable items"

  def uk_sortable(assigns) do
    sortable_opts =
      [
        assigns.group && "group: #{assigns.group}",
        assigns.animation && "animation: #{assigns.animation}",
        assigns.threshold && "threshold: #{assigns.threshold}",
        assigns.handle && "handle: #{assigns.handle}",
        assigns.cls_custom && "cls-custom: #{assigns.cls_custom}"
      ]
      |> Enum.reject(&is_nil/1)
      |> Enum.join("; ")

    assigns = assign(assigns, :sortable_opts, sortable_opts)

    ~H"""
    <div
      id={@id}
      uk-sortable={@sortable_opts}
      uk-grid={if @grid, do: true}
      class={["uk-sortable", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a UIkit icon.

  Uses the UIkit icon system to display SVG icons. Can be rendered as a standalone icon,
  a link, or an icon button.

  ## Examples

      <.uk_icon name="check" />
      <.uk_icon name="heart" ratio={2} />
      <.uk_icon name="trash" button href="/delete" />
      <.uk_icon name="twitter" href="https://twitter.com" />
  """
  attr :name, :string, required: true, doc: "the name of the icon"
  attr :ratio, :any, default: 1, doc: "the size multiplier of the icon"
  attr :id, :string, default: nil, doc: "the DOM ID of the icon"
  attr :button, :boolean, default: false, doc: "whether to render as an icon button"
  attr :class, :any, doc: "additional CSS classes"

  attr :rest, :global,
    include: ~w(href navigate patch method download uk-icon uk-toggle),
    doc: "the arbitrary HTML attributes to add to the icon container"

  def uk_icon(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> build_icon_class(assigns) end)
      |> assign(:icon_opts, build_icon_opts(assigns))

    assigns = assign(assigns, :rest, Map.put(assigns.rest, :"uk-icon", assigns.icon_opts))

    if assigns.rest[:href] || assigns.rest[:navigate] || assigns.rest[:patch] do
      ~H"""
      <.link id={@id} class={@class} phx-update="ignore" {@rest}></.link>
      """
    else
      ~H"""
      <span id={@id} class={@class} phx-update="ignore" {@rest}></span>
      """
    end
  end

  defp build_icon_opts(assigns) do
    [
      "icon: #{assigns.name}",
      assigns.ratio != 1 && "ratio: #{assigns.ratio}"
    ]
    |> Enum.reject(&(!&1))
    |> Enum.join("; ")
  end

  defp build_icon_class(assigns) do
    is_link = assigns.rest[:href] || assigns.rest[:navigate] || assigns.rest[:patch]

    [
      "uk-icon",
      assigns.button && "uk-icon-button",
      is_link && !assigns.button && "uk-icon-link"
    ]
  end

  @doc """
  Renders a UIkit modal.

  Modals provide a dialog box that sits on top of the main content.

  ## Examples

      <.uk_modal id="my-modal">
        <:header>
          <.uk_modal_title>Modal Title</.uk_modal_title>
        </:header>
        <:body>
          <p>Modal content goes here.</p>
        </:body>
        <:footer class="uk-text-right">
          <.uk_button class="uk-modal-close">Cancel</.uk_button>
          <.uk_button variant="primary">Save</.uk_button>
        </:footer>
      </.uk_modal>

  To trigger the modal, use `uk-toggle`:

      <.uk_button uk_toggle="target: #my-modal">Open Modal</.uk_button>

  To trigger the modal from an assign:

      <.uk_modal id="my-modal" show={@show_modal} on_close="close_modal">
        ...
      </.uk_modal>
  """
  attr :id, :string, required: true, doc: "the DOM ID of the modal"
  attr :center, :boolean, default: false, doc: "whether to vertically center the modal"

  attr :container, :any,
    default: false,
    doc: "target container. Defaults to false for LiveView compatibility (stays in DOM)"

  attr :full, :boolean, default: false, doc: "whether to make the modal full screen"

  attr :esc_close, :boolean,
    default: true,
    doc: "whether the modal can be closed by pressing the Esc key"

  attr :bg_close, :boolean,
    default: true,
    doc: "whether the modal can be closed by clicking on the background"

  attr :stack, :boolean, default: false, doc: "whether modals should stack"
  attr :show, :boolean, default: nil, doc: "programmatically show/hide the modal"
  attr :on_close, :string, default: nil, doc: "event to push when modal is closed manually"
  attr :class, :any, default: nil, doc: "additional CSS classes for the modal container"
  attr :dialog_class, :any, default: nil, doc: "additional CSS classes for the modal dialog"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the modal container"

  slot :header, doc: "the modal header content"
  slot :body, doc: "the modal body content"

  slot :footer, doc: "the modal footer content" do
    attr :class, :any, doc: "additional CSS classes for the footer"
  end

  slot :close, doc: "custom close button. If not provided, a default one is included"
  slot :inner_block, doc: "inner content, if not using structured slots"

  def uk_modal(assigns) do
    modal_opts =
      [
        assigns.esc_close == false && "esc-close: false",
        assigns.bg_close == false && "bg-close: false",
        assigns.stack == true && "stack: true",
        "container: #{assigns.container}"
      ]
      |> Enum.reject(&(!&1))
      |> Enum.join("; ")

    assigns =
      assigns
      |> assign(:modal_opts, modal_opts)
      |> assign(:rest, prepare_modal_rest(assigns))

    ~H"""
    <div
      id={@id}
      uk-modal={if @modal_opts == "", do: true, else: @modal_opts}
      class={[
        "uk-modal",
        @full && "uk-modal-full",
        @center && "uk-flex-top",
        @class
      ]}
      {@rest}
    >
      <div class={[
        "uk-modal-dialog",
        @container == true && "uk-modal-container",
        @center && "uk-margin-auto-vertical",
        @dialog_class
      ]}>
        <%= if @close != [] do %>
          {render_slot(@close)}
        <% else %>
          <button
            class={if @full, do: "uk-modal-close-full", else: "uk-modal-close-default"}
            type="button"
            uk-close
          >
          </button>
        <% end %>

        <div :if={@header != []} class="uk-modal-header">
          {render_slot(@header)}
        </div>

        <div :if={@body != []} class="uk-modal-body">
          {render_slot(@body)}
        </div>

        {render_slot(@inner_block)}

        <div :if={@footer != []} class={["uk-modal-footer", Enum.at(@footer, 0)[:class]]}>
          {render_slot(@footer)}
        </div>
      </div>
    </div>
    """
  end

  defp prepare_modal_rest(assigns) do
    rest = assigns.rest

    rest =
      if assigns.show == nil do
        rest
      else
        rest
        |> Map.put(:"data-show", to_string(assigns.show))
        |> Map.put(:"phx-hook", rest[:"phx-hook"] || "Modal")
      end

    if assigns.on_close do
      Map.put(rest, :"data-on-close", assigns.on_close)
    else
      rest
    end
  end

  @doc """
  Renders a title for the modal component.
  """
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the title"
  slot :inner_block, required: true, doc: "the title text"

  def uk_modal_title(assigns) do
    ~H"""
    <h2 class={["uk-modal-title", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h2>
    """
  end

  @doc """
  Renders a UIkit label.

  Labels are used to indicate a status or category.

  ## Examples

      <.uk_label>Default</.uk_label>
      <.uk_label variant="success">Success</.uk_label>
      <.uk_label variant="warning">Warning</.uk_label>
      <.uk_label variant="danger">Danger</.uk_label>
  """
  attr :variant, :string,
    default: nil,
    values: [nil, "success", "warning", "danger"],
    doc: "the visual style of the label"

  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the label container"
  slot :inner_block, required: true, doc: "the content of the label"

  def uk_label(assigns) do
    ~H"""
    <span
      class={[
        "uk-label",
        @variant && "uk-label-#{@variant}",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a UIkit spinner.

  Spinners are used to indicate loading states.

  ## Examples

      <.uk_spinner />
      <.uk_spinner ratio={2} />
  """
  attr :ratio, :any, default: 1, doc: "the size multiplier of the spinner"
  attr :id, :string, default: nil, doc: "the DOM ID of the spinner"
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the spinner container"

  def uk_spinner(assigns) do
    assigns =
      assigns
      |> assign(:spinner_opts, build_spinner_opts(assigns))

    assigns =
      assign(
        assigns,
        :rest,
        Map.put(
          assigns.rest,
          :"uk-spinner",
          if(assigns.spinner_opts == "", do: true, else: assigns.spinner_opts)
        )
      )

    ~H"""
    <div id={@id} class={@class} phx-update="ignore" {@rest}></div>
    """
  end

  defp build_spinner_opts(assigns) do
    [
      assigns.ratio != 1 && "ratio: #{assigns.ratio}"
    ]
    |> Enum.reject(&(!&1))
    |> Enum.join("; ")
  end

  @doc """
  Renders a UIkit subnav.

  Subnavs are used to create navigation for smaller sections of a page.

  ### Important: IDs and LiveView
  When using `switcher` or `active` attributes, UIkit and LiveView both manipulate the DOM.
  To prevent "ghost" nodes or duplicated elements during patching, **always provide a unique `id`**
  to the `<.uk_subnav>` component. The component will then automatically generate stable IDs
  for all nested items and links.

  ## Examples

      <.uk_subnav id="my-subnav" pill switcher="connect: #my-content">
        <:item href="#1">Item 1</:item>
        <:item href="#2">Item 2</:item>
      </.uk_subnav>
  """
  attr :divider, :boolean, default: false, doc: "whether to show a divider between items"
  attr :pill, :boolean, default: false, doc: "whether to show items as pills"
  attr :switcher, :any, default: false, doc: "options for uk-switcher"

  attr :active, :integer,
    default: nil,
    doc: "the index of the active item (programmatic control)"

  attr :id, :string, required: true, doc: "the DOM ID of the subnav (required for stability)"
  attr :on_change, :string, default: nil, doc: "event to push when switcher changes"
  attr :class, :any, default: nil, doc: "additional CSS classes for the list"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the subnav container"

  slot :item, doc: "the navigation items" do
    attr :id, :string,
      doc: "the DOM ID of the item. Falling back to an auto-generated ID if the parent has one."

    attr :href, :string, doc: "the link destination"
    attr :active, :boolean, doc: "whether the item is currently active"
    attr :disabled, :boolean, doc: "whether the item is disabled"
    attr :class, :any, doc: "additional CSS classes for the item container (li)"
  end

  def uk_subnav(assigns) do
    assigns = assign(assigns, :rest, prepare_subnav_rest(assigns))

    ~H"""
    <ul
      id={@id}
      class={[
        "uk-subnav",
        @divider && "uk-subnav-divider",
        @pill && "uk-subnav-pill",
        @class
      ]}
      {@rest}
    >
      <li
        :for={{item, index} <- Enum.with_index(@item)}
        id={item[:id] || (@id && "#{@id}-item-#{index}")}
        class={[
          item[:active] && "uk-active",
          item[:disabled] && "uk-disabled",
          item[:class]
        ]}
      >
        <%= if item[:disabled] do %>
          <span
            id={item[:id] && "#{item[:id]}-link"}
            {Map.drop(item, [:id, :href, :active, :disabled, :class, :inner_block])}
          >
            {render_slot(item)}
          </span>
        <% else %>
          <.link
            id={item[:id] && "#{item[:id]}-link"}
            href={item[:href]}
            {Map.drop(item, [:id, :href, :active, :disabled, :class, :inner_block])}
          >
            {render_slot(item)}
          </.link>
        <% end %>
      </li>
    </ul>
    """
  end

  defp prepare_subnav_rest(assigns) do
    rest = assigns.rest

    rest =
      if assigns.switcher do
        Map.put(
          rest,
          :"uk-switcher",
          if(assigns.switcher == true, do: true, else: assigns.switcher)
        )
      else
        rest
      end

    rest =
      if assigns.active == nil do
        rest
      else
        rest
        |> Map.put(:"data-active", assigns.active)
        |> Map.put(:"phx-hook", rest[:"phx-hook"] || "Switcher")
      end

    if assigns.on_change do
      Map.put(rest, :"data-on-change", assigns.on_change)
    else
      rest
    end
  end

  @doc """
  Renders a UIkit switcher content container.

  ### Important: IDs
  The `id` provided here must match the `connect` selector used in the corresponding
  navigation component (e.g., `<.uk_subnav switcher="connect: #my-id">`).

  ## Examples

      <.uk_subnav id="my-nav" switcher="connect: #my-switcher">
        <:item href="#">Item 1</:item>
        <:item href="#">Item 2</:item>
      </.uk_subnav>

      <.uk_switcher id="my-switcher">
        <li>Content 1</li>
        <li>Content 2</li>
      </.uk_switcher>
  """
  attr :id, :string, required: true, doc: "the DOM ID of the switcher"
  attr :animation, :string, default: nil, doc: "animation modifier"
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the switcher container"
  slot :inner_block, required: true, doc: "the content panes (li elements)"

  def uk_switcher(assigns) do
    ~H"""
    <ul
      id={@id}
      class={[
        "uk-switcher",
        @animation && "uk-animation-#{@animation}",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </ul>
    """
  end
end
