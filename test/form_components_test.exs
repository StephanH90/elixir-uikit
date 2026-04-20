defmodule Uikit.FormComponentsTest do
  use ExUnit.Case, async: false

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
end
