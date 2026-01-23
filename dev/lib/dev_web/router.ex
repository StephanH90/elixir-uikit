defmodule DevWeb.Router do
  use DevWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {DevWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DevWeb do
    pipe_through(:browser)

    live("/", HomeLive)
    live("/sortable", SortableLive)
  end

  # Other scopes may use custom stacks.
  # scope "/api", DevWeb do
  #   pipe_through :api
  # end
end
