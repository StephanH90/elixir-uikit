defmodule DevWeb.Components.TableTest do
  use DevWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "uk_table/1 rendering" do
    test "renders table with base uk-table class", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "uk-table"
    end

    test "striped modifier is present in demo", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "uk-table-striped"
    end

    test "divider modifier is present in demo", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "uk-table-divider"
    end

    test "hover modifier is present in demo", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "uk-table-hover"
    end

    test "small modifier is present in demo", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "uk-table-small"
    end

    test "responsive wrapper renders uk-overflow-auto", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "uk-overflow-auto"
    end

    test "table section renders thead and tbody", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "<thead>"
      assert html =~ "<tbody>"
    end

    test "live table renders initial rows from assigns", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/")
      assert html =~ "table-row-1"
      assert html =~ "table-row-2"
      assert html =~ "table-row-3"
    end

    test "add row button appends a new row to the table", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      html = view |> element("#add-table-row") |> render_click()

      assert html =~ "table-row-4"
    end

    test "multiple row additions accumulate", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      view |> element("#add-table-row") |> render_click()
      html = view |> element("#add-table-row") |> render_click()

      assert html =~ "table-row-4"
      assert html =~ "table-row-5"
    end
  end
end
