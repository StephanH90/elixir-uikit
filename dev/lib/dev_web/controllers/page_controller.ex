defmodule DevWeb.PageController do
  use DevWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
