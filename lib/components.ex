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
    doc: "The visual style of the button."

  attr :size, :string,
    default: nil,
    values: [nil, "small", "large"],
    doc: "The size of the button."

  attr :type, :string,
    default: "button",
    doc: "The HTML type of the button (submit, reset, button)."

  attr :class, :string, default: nil, doc: "Additional CSS classes."

  attr :rest, :global,
    include: ~w(href navigate patch method download),
    doc: "Global attributes or link-specific attributes."

  slot :inner_block, required: true, doc: "The content of the button."

  def uk_button(assigns) do
    class = [
      "uk-button",
      "uk-button-#{assigns.variant}",
      assigns.size && "uk-button-#{assigns.size}",
      assigns.class
    ]

    assigns = assign(assigns, :class, class)

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

  @doc """
  Renders a UIkit badge.

  Badges are used to highlight information, such as counts or labels.

  ## Examples

      <.uk_badge>1</.uk_badge>
      <.uk_badge class="uk-label-success">100</.uk_badge>
  """
  attr :class, :string, default: nil, doc: "Additional CSS classes."
  attr :rest, :global, doc: "Global attributes."
  slot :inner_block, required: true, doc: "The content of the badge."

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
    doc: "The style variant of the card."

  attr :size, :string,
    default: nil,
    values: [nil, "small", "large"],
    doc: "The padding size of the card."

  attr :hover, :boolean, default: false, doc: "Whether to add a hover effect."
  attr :class, :string, default: nil, doc: "Additional CSS classes."
  attr :rest, :global, doc: "Global attributes."

  slot :header, doc: "The card header content."
  slot :body, doc: "The card body content."
  slot :footer, doc: "The card footer content."
  slot :inner_block, doc: "Inner content, if not using structured slots."

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
      <div :if={@header} class="uk-card-header">
        {render_slot(@header)}
      </div>

      <div :if={@body} class="uk-card-body">
        {render_slot(@body)}
      </div>

      {render_slot(@inner_block)}

      <div :if={@footer} class="uk-card-footer">
        {render_slot(@footer)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a title for the card component.
  """
  attr :class, :string, default: nil, doc: "Additional CSS classes."
  attr :rest, :global, doc: "Global attributes."
  slot :inner_block, required: true, doc: "The title text."

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
    doc: "The max-width of the container."

  attr :class, :string, default: nil, doc: "Additional CSS classes."
  attr :rest, :global, doc: "Global attributes."
  slot :inner_block, required: true, doc: "The container content."

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
    doc: "The grid gap size."

  attr :divider, :boolean, default: false, doc: "Whether to show a divider between cells."
  attr :match, :boolean, default: false, doc: "Whether to match the height of grid cells."

  attr :masonry, :string,
    default: nil,
    values: [nil, "pack", "next", "true"],
    doc: "Enables masonry layout."

  attr :class, :string, default: nil, doc: "Additional CSS classes."
  attr :rest, :global, doc: "Global attributes."
  slot :inner_block, required: true, doc: "The grid items."

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

  Enables drag and drop reordering of items. Requires the `Sortable` hook for LiveView integration.

  ## Examples

      <.uk_sortable id="my-sortable" group="my-group" grid phx-hook="Sortable">
        <div id="item-1">Item 1</div>
        <div id="item-2">Item 2</div>
      </.uk_sortable>
  """
  attr :id, :string, required: true, doc: "The DOM ID of the container (required for hooks)."
  attr :group, :string, default: nil, doc: "The group name for dragging between lists."
  attr :animation, :integer, default: nil, doc: "Animation duration in milliseconds."
  attr :threshold, :integer, default: nil, doc: "Mouse move threshold before dragging starts."
  attr :handle, :string, default: nil, doc: "Selector for the drag handle."
  attr :cls_custom, :string, default: nil, doc: "Custom class for the dragged item."
  attr :grid, :boolean, default: false, doc: "Whether to apply the grid component behavior."
  attr :class, :string, default: nil, doc: "Additional CSS classes."
  attr :rest, :global, doc: "Global attributes (e.g. phx-hook)."
  slot :inner_block, required: true, doc: "The sortable items."

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
      uk-grid={@grid}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
