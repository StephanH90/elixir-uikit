defmodule Uikit.Components do
  use Phoenix.Component

  @doc """
  A standard UIkit button.

  ## Examples
      <.uk_button variant="primary">Click me</.uk_button>
  """
  attr :variant, :string,
    default: "default",
    values: ~w(default primary secondary danger text link)

  attr :size, :string, default: nil, values: [nil, "small", "large"]
  attr :type, :string, default: "button"
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def uk_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "uk-button",
        "uk-button-#{@variant}",
        @size && "uk-button-#{@size}",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  A standard UIkit badge.

  ## Examples
      <.uk_badge>1</.uk_badge>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def uk_badge(assigns) do
    ~H"""
    <span class={["uk-badge", @class]} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  A standard UIkit card.

  ## Examples

      <.uk_card>
        <:header>
          <.uk_card_title>Title</.uk_card_title>
        </:header>
        <:body>
          Content
        </:body>
        <:footer>
          <a href="#" class="uk-button uk-button-text">Read more</a>
        </:footer>
      </.uk_card>
  """
  attr :variant, :string, default: "default", values: ~w(default primary secondary)
  attr :size, :string, default: nil, values: [nil, "small", "large"]
  attr :hover, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  slot :header
  slot :body
  slot :footer
  slot :inner_block

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
  Title component for the card.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def uk_card_title(assigns) do
    ~H"""
    <h3 class={["uk-card-title", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  @doc """
  A standard UIkit container.

  ## Examples
      <.uk_container size="small">
        Content
      </.uk_container>
  """
  attr :size, :string, default: nil, values: [nil, "xsmall", "small", "large", "xlarge", "expand"]
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

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
  A standard UIkit grid.

  ## Examples
      <.uk_grid gap="small" match>
        <div>Item 1</div>
        <div>Item 2</div>
      </.uk_grid>
  """
  attr :gap, :string, default: nil, values: [nil, "small", "medium", "large", "collapse"]
  attr :divider, :boolean, default: false
  attr :match, :boolean, default: false
  attr :masonry, :string, default: nil, values: [nil, "pack", "next", "true"]
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

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
end
