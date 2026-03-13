defmodule Uikit.FormComponents do
  @moduledoc """
  Provides UIkit form components for Phoenix LiveView applications.

  These components integrate with `Phoenix.HTML.FormField` for seamless use
  with `<.form>` and `to_form/2`-based forms, including error display and
  field name/id generation.

  ## Usage

  Import this module alongside `Uikit.Components` in your web interface:

      defp html_helpers do
        quote do
          import Uikit.Components
          import Uikit.FormComponents
        end
      end

  ## Basic Example

      <.uk_form for={@form} id="user-form" phx-change="validate" phx-submit="save">
        <.uk_fieldset>
          <:legend>User Details</:legend>
          <.uk_input field={@form[:name]} label="Full Name" />
          <.uk_input field={@form[:email]} type="email" label="Email" />
          <.uk_input field={@form[:role]} type="select" label="Role" options={["Admin", "User"]} />
          <.uk_input field={@form[:bio]} type="textarea" label="Bio" />
        </.uk_fieldset>
      </.uk_form>
  """
  use Phoenix.Component

  @doc """
  Renders a UIkit-styled form wrapper.

  Wraps `<.form>` with optional UIkit layout classes.

  ## Examples

      <.uk_form for={@form} id="my-form" phx-submit="save">
        ...
      </.uk_form>

      <.uk_form for={@form} id="my-form" layout="stacked" phx-submit="save">
        ...
      </.uk_form>
  """
  attr :for, :any, required: true, doc: "the form data source (result of to_form/2)"
  attr :id, :string, required: true, doc: "the DOM ID of the form (required for LiveView)"

  attr :layout, :string,
    default: nil,
    values: [nil, "stacked", "horizontal"],
    doc: "the UIkit form layout — stacked places labels above, horizontal places them beside"

  attr :class, :any, default: nil, doc: "additional CSS classes"

  attr :rest, :global,
    include: ~w(action method phx-change phx-submit phx-trigger-action autocomplete),
    doc: "arbitrary HTML attributes for the form element"

  slot :inner_block, required: true, doc: "the form fields"

  def uk_form(assigns) do
    ~H"""
    <.form
      for={@for}
      id={@id}
      class={[
        @layout && "uk-form-#{@layout}",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.form>
    """
  end

  @doc """
  Renders a UIkit input with label and error messages.

  Accepts a `Phoenix.HTML.FormField` via the `field` attribute for automatic
  `id`, `name`, `value`, and error extraction. All attributes can also be
  passed explicitly when not using a form field.

  ## Types

  Supports all standard HTML input types. Use `type="select"` to render a
  `<select>` and `type="textarea"` to render a `<textarea>`.

  For checkboxes, use `<.uk_checkbox>` instead (handles hidden field for false value).

  ## Examples

      <.uk_input field={@form[:email]} type="email" label="Email" />
      <.uk_input field={@form[:username]} label="Username" size="large" />
      <.uk_input field={@form[:bio]} type="textarea" label="Bio" rows="4" />
      <.uk_input field={@form[:role]} type="select" label="Role"
                 options={["Admin": "admin", "User": "user"]} />
      <.uk_input name="search" type="search" placeholder="Search..." />
  """
  attr :id, :any, default: nil, doc: "the DOM ID of the input"
  attr :name, :any, doc: "the name of the input"
  attr :label, :string, default: nil, doc: "the label text"
  attr :value, :any, doc: "the input value"

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
         range search select tel text textarea time url week),
    doc: "the HTML input type, or select/textarea"

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct from the form, e.g. @form[:email]"

  attr :errors, :list, default: [], doc: "error messages to display below the input"
  attr :prompt, :string, default: nil, doc: "a blank prompt option for select inputs"

  attr :options, :list,
    doc: "options for select inputs (see Phoenix.HTML.Form.options_for_select/2)"

  attr :multiple, :boolean, default: false, doc: "allow multiple selections in a select"

  attr :size, :string,
    default: nil,
    values: [nil, "small", "large"],
    doc: "the UIkit size modifier"

  attr :width, :string,
    default: nil,
    values: [nil, "xsmall", "small", "medium", "large"],
    doc: "the UIkit form width modifier"

  attr :state, :string,
    default: nil,
    values: [nil, "danger", "success"],
    doc: "the UIkit validation state; automatically set to danger when there are errors"

  attr :blank, :boolean, default: false, doc: "minimizes form control styling (uk-form-blank)"
  attr :class, :any, default: nil, doc: "additional CSS classes"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
         multiple pattern placeholder readonly required rows step),
    doc: "arbitrary HTML attributes passed to the input element"

  def uk_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error/1))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> uk_input()
  end

  def uk_input(%{type: "hidden"} = assigns) do
    ~H"""
    <input type="hidden" id={@id} name={@name} value={@value} {@rest} />
    """
  end

  def uk_input(%{type: "select"} = assigns) do
    effective_state = if assigns.errors == [], do: assigns.state, else: assigns.state || "danger"

    assigns = assign(assigns, :effective_state, effective_state)

    ~H"""
    <div>
      <label :if={@label} class="uk-form-label" for={@id}>{@label}</label>
      <div class="uk-form-controls">
        <select
          id={@id}
          name={@name}
          multiple={@multiple}
          class={[
            "uk-select",
            @size && "uk-form-#{@size}",
            @width && "uk-form-width-#{@width}",
            @effective_state && "uk-form-#{@effective_state}",
            @blank && "uk-form-blank",
            @class
          ]}
          {@rest}
        >
          <option :if={@prompt} value="">{@prompt}</option>
          {Phoenix.HTML.Form.options_for_select(@options, @value)}
        </select>
      </div>
      <.uk_field_errors errors={@errors} />
    </div>
    """
  end

  def uk_input(%{type: "textarea"} = assigns) do
    effective_state = if assigns.errors == [], do: assigns.state, else: assigns.state || "danger"

    assigns = assign(assigns, :effective_state, effective_state)

    ~H"""
    <div>
      <label :if={@label} class="uk-form-label" for={@id}>{@label}</label>
      <div class="uk-form-controls">
        <textarea
          id={@id}
          name={@name}
          class={[
            "uk-textarea",
            @size && "uk-form-#{@size}",
            @width && "uk-form-width-#{@width}",
            @effective_state && "uk-form-#{@effective_state}",
            @blank && "uk-form-blank",
            @class
          ]}
          {@rest}
        >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
      </div>
      <.uk_field_errors errors={@errors} />
    </div>
    """
  end

  # Catch-all for text, email, password, date, number, url, tel, etc.
  def uk_input(assigns) do
    effective_state = if assigns.errors == [], do: assigns.state, else: assigns.state || "danger"

    assigns = assign(assigns, :effective_state, effective_state)

    ~H"""
    <div>
      <label :if={@label} class="uk-form-label" for={@id}>{@label}</label>
      <div class="uk-form-controls">
        <input
          type={@type}
          id={@id}
          name={@name}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            "uk-input",
            @size && "uk-form-#{@size}",
            @width && "uk-form-width-#{@width}",
            @effective_state && "uk-form-#{@effective_state}",
            @blank && "uk-form-blank",
            @class
          ]}
          {@rest}
        />
      </div>
      <.uk_field_errors errors={@errors} />
    </div>
    """
  end

  @doc """
  Renders a UIkit checkbox with label and error messages.

  Includes the hidden `false` value input required for LiveView form handling.

  ## Examples

      <.uk_checkbox field={@form[:agree]} label="I agree to the terms" />
      <.uk_checkbox name="notifications" label="Enable notifications" checked />
  """
  attr :id, :any, default: nil, doc: "the DOM ID of the checkbox"
  attr :name, :any, doc: "the name of the checkbox"
  attr :label, :string, default: nil, doc: "the label text shown beside the checkbox"
  attr :value, :any, default: "true", doc: "the value submitted when checked"
  attr :checked, :boolean, doc: "whether the checkbox is checked"

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct from the form, e.g. @form[:agree]"

  attr :errors, :list, default: [], doc: "error messages to display below the checkbox"

  attr :state, :string,
    default: nil,
    values: [nil, "danger", "success"],
    doc: "the UIkit validation state"

  attr :class, :any, default: nil, doc: "additional CSS classes"

  attr :rest, :global,
    include: ~w(disabled form required),
    doc: "arbitrary HTML attributes passed to the checkbox input"

  def uk_checkbox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error/1))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:checked, fn ->
      Phoenix.HTML.Form.normalize_value("checkbox", field.value)
    end)
    |> uk_checkbox()
  end

  def uk_checkbox(assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    effective_state = if assigns.errors == [], do: assigns.state, else: assigns.state || "danger"

    assigns = assign(assigns, :effective_state, effective_state)

    ~H"""
    <div>
      <div style="display: inline-flex; align-items: center; gap: 0.4em">
        <input
          type="hidden"
          name={@name}
          value="false"
          disabled={@rest[:disabled]}
          form={@rest[:form]}
        />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value={@value}
          checked={@checked}
          class={[
            "uk-checkbox",
            @effective_state && "uk-form-#{@effective_state}",
            @class
          ]}
          {@rest}
        />
        <label :if={@label} for={@id}>{@label}</label>
      </div>
      <.uk_field_errors errors={@errors} />
    </div>
    """
  end

  @doc """
  Renders a UIkit radio input.

  Use multiple `<.uk_radio>` components with the same `name` to create a group.

  ## Examples

      <.uk_radio field={@form[:role]} value="admin" label="Admin" />
      <.uk_radio field={@form[:role]} value="user" label="User" />

      <.uk_radio name="color" value="red" label="Red" />
      <.uk_radio name="color" value="blue" label="Blue" />
  """
  attr :id, :any, default: nil, doc: "the DOM ID of the radio input"
  attr :name, :any, doc: "the name of the radio group"
  attr :label, :string, default: nil, doc: "the label text shown beside the radio"
  attr :value, :any, required: true, doc: "the value submitted when this radio is selected"
  attr :checked, :boolean, default: false, doc: "whether this radio is selected"

  attr :field, Phoenix.HTML.FormField, doc: "a form field struct from the form, e.g. @form[:role]"

  attr :state, :string,
    default: nil,
    values: [nil, "danger", "success"],
    doc: "the UIkit validation state"

  attr :class, :any, default: nil, doc: "additional CSS classes"

  attr :rest, :global,
    include: ~w(disabled form required),
    doc: "arbitrary HTML attributes passed to the radio input"

  def uk_radio(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || "#{field.id}_#{assigns.value}")
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:checked, fn -> to_string(field.value) == to_string(assigns.value) end)
    |> uk_radio()
  end

  def uk_radio(assigns) do
    ~H"""
    <div style="display: inline-flex; align-items: center; gap: 0.4em">
      <input
        type="radio"
        id={@id}
        name={@name}
        value={@value}
        checked={@checked}
        class={[
          "uk-radio",
          @state && "uk-form-#{@state}",
          @class
        ]}
        {@rest}
      />
      <label :if={@label} for={@id}>{@label}</label>
    </div>
    """
  end

  @doc """
  Renders a UIkit range slider.

  ## Examples

      <.uk_range field={@form[:volume]} min="0" max="100" step="1" label="Volume" />
      <.uk_range name="opacity" min="0" max="1" step="0.1" />
  """
  attr :id, :any, default: nil, doc: "the DOM ID of the range input"
  attr :name, :any, doc: "the name of the range input"
  attr :label, :string, default: nil, doc: "the label text"
  attr :value, :any, doc: "the current value"

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct from the form, e.g. @form[:volume]"

  attr :errors, :list, default: [], doc: "error messages"
  attr :class, :any, default: nil, doc: "additional CSS classes"

  attr :rest, :global,
    include: ~w(min max step disabled form required),
    doc: "arbitrary HTML attributes passed to the range input"

  def uk_range(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error/1))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> uk_range()
  end

  def uk_range(assigns) do
    ~H"""
    <div>
      <label :if={@label} class="uk-form-label" for={@id}>{@label}</label>
      <div class="uk-form-controls">
        <input
          type="range"
          id={@id}
          name={@name}
          value={@value}
          class={["uk-range", @class]}
          {@rest}
        />
      </div>
      <.uk_field_errors errors={@errors} />
    </div>
    """
  end

  @doc """
  Renders a UIkit fieldset with optional legend slot.

  ## Examples

      <.uk_fieldset>
        <:legend>Personal Information</:legend>
        <.uk_input field={@form[:name]} label="Name" />
      </.uk_fieldset>
  """
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "arbitrary HTML attributes for the fieldset"

  slot :legend, doc: "the fieldset legend text"
  slot :inner_block, required: true, doc: "the fieldset content"

  def uk_fieldset(assigns) do
    ~H"""
    <fieldset class={["uk-fieldset", @class]} {@rest}>
      <legend :if={@legend != []} class="uk-legend">{render_slot(@legend)}</legend>
      {render_slot(@inner_block)}
    </fieldset>
    """
  end

  @doc """
  Renders a UIkit form label.

  ## Examples

      <.uk_form_label for="user-email">Email</.uk_form_label>
  """
  attr :for, :string, default: nil, doc: "the id of the associated form control"
  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "arbitrary HTML attributes for the label"
  slot :inner_block, required: true, doc: "the label text"

  def uk_form_label(assigns) do
    ~H"""
    <label for={@for} class={["uk-form-label", @class]} {@rest}>
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Renders a UIkit form controls wrapper.

  Use inside a horizontal form to wrap inputs alongside labels.
  Use `text` for checkboxes/radios in horizontal forms to improve alignment.

  ## Examples

      <.uk_form_controls>
        <.uk_input name="email" type="email" />
      </.uk_form_controls>

      <.uk_form_controls text>
        <.uk_checkbox name="agree" label="I agree" />
      </.uk_form_controls>
  """
  attr :text, :boolean,
    default: false,
    doc: "adds uk-form-controls-text for checkbox/radio alignment in horizontal forms"

  attr :class, :any, default: nil, doc: "additional CSS classes"
  attr :rest, :global, doc: "arbitrary HTML attributes"
  slot :inner_block, required: true, doc: "the form controls content"

  def uk_form_controls(assigns) do
    ~H"""
    <div
      class={[
        "uk-form-controls",
        @text && "uk-form-controls-text",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a UIkit form icon — an icon positioned inside an input.

  Wrap this around your `<.uk_input>` (without the outer div) or a plain `<input>`.
  The input must have its label managed externally (pass `label={nil}` to `uk_input`
  and use `<.uk_form_label>` above).

  ## Examples

      <.uk_form_label for="user-email">Email</.uk_form_label>
      <.uk_form_icon icon="mail">
        <input class="uk-input" type="email" id="user-email" name="user[email]" />
      </.uk_form_icon>

      <.uk_form_label for="search">Search</.uk_form_label>
      <.uk_form_icon icon="search" flip clickable>
        <input class="uk-input" type="search" id="search" name="search" />
      </.uk_form_icon>
  """
  attr :icon, :string, required: true, doc: "the UIkit icon name"

  attr :flip, :boolean,
    default: false,
    doc: "positions the icon on the right side (uk-form-icon-flip)"

  attr :clickable, :boolean,
    default: false,
    doc: "renders the icon as a clickable <a> element"

  attr :class, :any, default: nil, doc: "additional CSS classes for the icon element"

  attr :rest, :global,
    include: ~w(href navigate patch phx-click),
    doc: "arbitrary HTML attributes for the icon element"

  slot :inner_block, required: true, doc: "the input element"

  def uk_form_icon(assigns) do
    ~H"""
    <div class="uk-inline">
      <%= if @clickable do %>
        <a
          class={["uk-form-icon", @flip && "uk-form-icon-flip", @class]}
          uk-icon={"icon: #{@icon}"}
          {@rest}
        >
        </a>
      <% else %>
        <span
          class={["uk-form-icon", @flip && "uk-form-icon-flip", @class]}
          uk-icon={"icon: #{@icon}"}
        >
        </span>
      <% end %>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # Private component to render a list of field errors below an input.
  defp uk_field_errors(assigns) do
    ~H"""
    <p :for={msg <- @errors} class="uk-text-danger uk-text-small uk-margin-small-top">
      {msg}
    </p>
    """
  end

  @doc """
  Translates a form field error tuple into a human-readable string.

  This mirrors the `translate_error/1` generated by Phoenix, interpolating
  `%{key}` placeholders with their values from the opts keyword list.
  """
  def translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
