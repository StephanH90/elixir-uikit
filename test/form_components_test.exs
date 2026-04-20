defmodule Uikit.FormComponentsTest do
  use ExUnit.Case, async: false

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import Uikit.FormComponents

  alias Uikit.FormComponents

  setup do
    Application.delete_env(:elixir_uikit, :error_translator)
    on_exit(fn -> Application.delete_env(:elixir_uikit, :error_translator) end)
    :ok
  end

  describe "translate_error/1" do
    test "default: interpolates %{key} placeholders" do
      error = {"must be at least %{count} characters", [count: 5]}
      assert FormComponents.translate_error(error) == "must be at least 5 characters"
    end

    test "default: handles multiple placeholders" do
      error = {"must be between %{min} and %{max}", [min: 1, max: 10]}
      assert FormComponents.translate_error(error) == "must be between 1 and 10"
    end

    test "default: returns message unchanged when no placeholders" do
      error = {"can't be blank", []}
      assert FormComponents.translate_error(error) == "can't be blank"
    end

    test "with {module, function} tuple" do
      Application.put_env(:elixir_uikit, :error_translator, {__MODULE__, :custom_translator})

      error = {"test message", [key: "value"]}
      assert FormComponents.translate_error(error) == "CUSTOM: test message"
    end
  end

  def custom_translator({msg, _opts}) do
    "CUSTOM: #{msg}"
  end

  describe "uk_input label slot" do
    test "renders text label content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_input id="name" name="name" value="">
          <:label>Full Name</:label>
        </.uk_input>
        """)

      assert html =~ ~s(<label class="uk-form-label" for="name">)
      assert html =~ "Full Name"
    end

    test "renders HTML label content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_input id="name" name="name" value="">
          <:label>Name <span class="uk-text-danger">*</span></:label>
        </.uk_input>
        """)

      assert html =~ ~s(<span class="uk-text-danger">*</span>)
    end

    test "omits label element when slot empty" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_input id="name" name="name" value="" />
        """)

      refute html =~ "uk-form-label"
    end

    test "renders label for select variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_input id="role" name="role" type="select" value="" options={["A", "B"]}>
          <:label>Role <em>required</em></:label>
        </.uk_input>
        """)

      assert html =~ ~s(<label class="uk-form-label" for="role">)
      assert html =~ "<em>required</em>"
    end

    test "renders label for textarea variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_input id="bio" name="bio" type="textarea" value="">
          <:label>Biography</:label>
        </.uk_input>
        """)

      assert html =~ ~s(<label class="uk-form-label" for="bio">)
      assert html =~ "Biography"
    end
  end

  describe "uk_checkbox label slot" do
    test "renders HTML label content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_checkbox id="agree" name="agree">
          <:label>I agree to the <strong>terms</strong></:label>
        </.uk_checkbox>
        """)

      assert html =~ ~s(<label for="agree">)
      assert html =~ "<strong>terms</strong>"
    end

    test "omits label when slot empty" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_checkbox id="agree" name="agree" />
        """)

      refute html =~ ~s(<label for="agree">)
    end
  end

  describe "uk_radio label slot" do
    test "renders HTML label content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_radio id="r-a" name="r" value="a">
          <:label><span class="uk-text-bold">Option A</span></:label>
        </.uk_radio>
        """)

      assert html =~ ~s(<label for="r-a">)
      assert html =~ ~s(<span class="uk-text-bold">Option A</span>)
    end

    test "omits label when slot empty" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_radio id="r-a" name="r" value="a" />
        """)

      refute html =~ ~s(<label for="r-a">)
    end
  end

  describe "uk_range label slot" do
    test "renders HTML label content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_range id="vol" name="vol" value="50">
          <:label>Volume <small>(0-100)</small></:label>
        </.uk_range>
        """)

      assert html =~ ~s(<label class="uk-form-label" for="vol">)
      assert html =~ "<small>(0-100)</small>"
    end

    test "omits label when slot empty" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.uk_range id="vol" name="vol" value="50" />
        """)

      refute html =~ "uk-form-label"
    end
  end
end
