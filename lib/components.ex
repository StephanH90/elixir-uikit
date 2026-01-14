defmodule Uikit.Components do
  use Phoenix.Component

  @doc """
  A standard UIkit button.

  ## Examples
      <.uk_button variant="primary">Click me</.uk_button>
  """
  attr(:variant, :string,
    default: "default",
    values: ~w(default primary secondary danger text link)
  )

  attr(:size, :string, default: nil, values: [nil, "small", "large"])
  attr(:type, :string, default: "button")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

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
end
