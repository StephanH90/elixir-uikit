defmodule DevWeb.FormLive do
  use DevWeb, :live_view

  import Uikit.FormComponents

  @roles [{"Admin", "admin"}, {"Editor", "editor"}, {"Viewer", "viewer"}]
  @plans [{"Free", "free"}, {"Pro", "pro"}, {"Enterprise", "enterprise"}]

  @empty_params %{
    "name" => "",
    "email" => "",
    "password" => "",
    "role" => "",
    "bio" => "",
    "newsletter" => "false",
    "plan" => "free",
    "volume" => "50"
  }

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, form: to_form(@empty_params, as: :user), submitted: false, saved_data: nil)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    errors = validate(params)
    {:noreply, assign(socket, form: to_form(params, as: :user, errors: errors))}
  end

  def handle_event("save", %{"user" => params}, socket) do
    errors = validate(params)

    if errors == [] do
      {:noreply,
       assign(socket, submitted: true, saved_data: params, form: to_form(params, as: :user))}
    else
      {:noreply,
       assign(socket, form: to_form(params, as: :user, errors: errors), submitted: false)}
    end
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     assign(socket, form: to_form(@empty_params, as: :user), submitted: false, saved_data: nil)}
  end

  defp validate(params) do
    []
    |> require_field(params, "name", "can't be blank")
    |> validate_length(params, "name", min: 2, max: 50)
    |> require_field(params, "email", "can't be blank")
    |> validate_format(params, "email", ~r/^[^\s]+@[^\s]+$/, "must include @")
    |> require_field(params, "password", "can't be blank")
    |> validate_length(params, "password", min: 8)
    |> require_field(params, "role", "can't be blank")
  end

  defp require_field(errors, params, field, msg) do
    if String.trim(params[field] || "") == "" do
      [{String.to_atom(field), {msg, []}} | errors]
    else
      errors
    end
  end

  defp validate_length(errors, params, field, opts) do
    val = String.trim(params[field] || "")
    min = opts[:min]
    max = opts[:max]

    cond do
      min && String.length(val) > 0 && String.length(val) < min ->
        [{String.to_atom(field), {"must be at least #{min} characters", []}} | errors]

      max && String.length(val) > max ->
        [{String.to_atom(field), {"must be at most #{max} characters", []}} | errors]

      true ->
        errors
    end
  end

  defp validate_format(errors, params, field, regex, msg) do
    val = String.trim(params[field] || "")

    if val != "" && !Regex.match?(regex, val) do
      [{String.to_atom(field), {msg, []}} | errors]
    else
      errors
    end
  end

  def render(assigns) do
    assigns = assign(assigns, roles: @roles, plans: @plans)

    ~H"""
    <.uk_section>
      <.uk_container size="small">
        <%!-- Page header --%>
        <div class="uk-margin-large-bottom">
          <.link navigate="/" class="uk-link-muted uk-text-small">
            ← Back to components
          </.link>
          <h1 class="uk-heading-medium uk-margin-small-top">Form Components</h1>
          <p class="uk-text-lead">
            Interactive demo of <code>Uikit.FormComponents</code> with real validation.
          </p>
        </div>

        <%!-- Success banner --%>
        <div :if={@submitted} class="uk-alert uk-alert-success" uk-alert>
          <a class="uk-alert-close" uk-close></a>
          <h3>Submitted successfully!</h3>
          <p>
            Name: <strong>{@saved_data["name"]}</strong> ·
            Email: <strong>{@saved_data["email"]}</strong> ·
            Role: <strong>{@saved_data["role"]}</strong> ·
            Plan: <strong>{@saved_data["plan"] || "—"}</strong> ·
            Newsletter: <strong>{@saved_data["newsletter"]}</strong>
          </p>
          <button class="uk-button uk-button-text uk-margin-small-top" phx-click="reset">
            Reset form
          </button>
        </div>

        <%!-- Main form demo: Stacked layout --%>
        <section class="uk-margin-large-bottom">
          <h2 class="uk-h2 uk-margin-small-bottom">Stacked layout</h2>
          <.uk_card>
            <:body>
              <.uk_form
                for={@form}
                id="user-form"
                layout="stacked"
                phx-change="validate"
                phx-submit="save"
              >
                <.uk_fieldset>
                  <:legend>Account Details</:legend>

                  <div class="uk-margin">
                    <.uk_input field={@form[:name]} label="Full Name" placeholder="Jane Smith" />
                  </div>

                  <div class="uk-margin">
                    <.uk_input
                      field={@form[:email]}
                      type="email"
                      label="Email"
                      placeholder="jane@example.com"
                    />
                  </div>

                  <div class="uk-margin">
                    <.uk_input
                      field={@form[:password]}
                      type="password"
                      label="Password"
                      placeholder="Min. 8 characters"
                    />
                  </div>

                  <div class="uk-margin">
                    <.uk_input
                      field={@form[:role]}
                      type="select"
                      label="Role"
                      prompt="Pick a role..."
                      options={@roles}
                    />
                  </div>

                  <div class="uk-margin">
                    <.uk_input
                      field={@form[:bio]}
                      type="textarea"
                      label="Bio"
                      placeholder="Tell us about yourself..."
                      rows="4"
                    />
                  </div>
                </.uk_fieldset>

                <.uk_fieldset class="uk-margin-top">
                  <:legend>Preferences</:legend>

                  <div class="uk-margin">
                    <p class="uk-text-small uk-text-muted uk-margin-small-bottom">Plan</p>
                    <div class="uk-flex uk-flex-column" style="gap: 0.5rem">
                      <.uk_radio
                        :for={{label, value} <- @plans}
                        field={@form[:plan]}
                        value={value}
                        label={label}
                      />
                    </div>
                  </div>

                  <div class="uk-margin">
                    <.uk_checkbox field={@form[:newsletter]} label="Subscribe to newsletter" />
                  </div>

                  <div class="uk-margin">
                    <.uk_input
                      field={@form[:volume]}
                      type="range"
                      label="Notification volume"
                      min="0"
                      max="100"
                      step="1"
                    />
                  </div>
                </.uk_fieldset>

                <div class="uk-margin-top">
                  <.uk_button type="submit" variant="primary">Save</.uk_button>
                  <.uk_button type="button" phx-click="reset" class="uk-margin-left">
                    Reset
                  </.uk_button>
                </div>
              </.uk_form>
            </:body>
          </.uk_card>
        </section>

        <%!-- Demo: Form icon --%>
        <section class="uk-margin-large-bottom">
          <h2 class="uk-h2 uk-margin-small-bottom">Form icon</h2>
          <.uk_card>
            <:body>
              <div class="uk-form-stacked">
                <div class="uk-margin">
                  <.uk_form_label for="icon-email">Email with icon</.uk_form_label>
                  <.uk_form_controls>
                    <.uk_form_icon icon="mail">
                      <input
                        class="uk-input"
                        type="email"
                        id="icon-email"
                        name="icon_email"
                        placeholder="jane@example.com"
                      />
                    </.uk_form_icon>
                  </.uk_form_controls>
                </div>
                <div class="uk-margin">
                  <.uk_form_label for="icon-search">Search with right-side icon</.uk_form_label>
                  <.uk_form_controls>
                    <.uk_form_icon icon="search" flip>
                      <input
                        class="uk-input"
                        type="search"
                        id="icon-search"
                        name="icon_search"
                        placeholder="Search..."
                      />
                    </.uk_form_icon>
                  </.uk_form_controls>
                </div>
              </div>
            </:body>
          </.uk_card>
        </section>

        <%!-- Demo: Size & width modifiers --%>
        <section class="uk-margin-large-bottom">
          <h2 class="uk-h2 uk-margin-small-bottom">Size &amp; width modifiers</h2>
          <.uk_card>
            <:body>
              <div class="uk-form-stacked">
                <div class="uk-margin">
                  <.uk_form_label>Small / medium-width</.uk_form_label>
                  <.uk_form_controls>
                    <input
                      class="uk-input uk-form-small uk-form-width-medium"
                      type="text"
                      placeholder="Small"
                    />
                  </.uk_form_controls>
                </div>
                <div class="uk-margin">
                  <.uk_form_label>Default / large-width</.uk_form_label>
                  <.uk_form_controls>
                    <input class="uk-input uk-form-width-large" type="text" placeholder="Default" />
                  </.uk_form_controls>
                </div>
                <div class="uk-margin">
                  <.uk_form_label>Large</.uk_form_label>
                  <.uk_form_controls>
                    <input class="uk-input uk-form-large" type="text" placeholder="Large" />
                  </.uk_form_controls>
                </div>
              </div>
            </:body>
          </.uk_card>
        </section>

        <%!-- Demo: Validation states --%>
        <section class="uk-margin-large-bottom">
          <h2 class="uk-h2 uk-margin-small-bottom">Static validation states</h2>
          <.uk_card>
            <:body>
              <div class="uk-form-stacked">
                <div class="uk-margin">
                  <.uk_form_label>Success input</.uk_form_label>
                  <input class="uk-input uk-form-success" type="text" value="Valid value" />
                </div>
                <div class="uk-margin">
                  <.uk_form_label>Danger input</.uk_form_label>
                  <input class="uk-input uk-form-danger" type="text" value="Invalid value" />
                </div>
                <div class="uk-margin">
                  <.uk_form_label>Success textarea</.uk_form_label>
                  <textarea class="uk-textarea uk-form-success" rows="2">Valid content</textarea>
                </div>
                <div class="uk-margin">
                  <.uk_form_label>Danger textarea</.uk_form_label>
                  <textarea class="uk-textarea uk-form-danger" rows="2">Invalid content</textarea>
                </div>
              </div>
            </:body>
          </.uk_card>
        </section>
      </.uk_container>
    </.uk_section>
    """
  end
end
