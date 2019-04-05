defmodule LfeviewWeb.Router do
  use LfeviewWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_layout, {LfeviewWeb.LayoutView, :app})
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", LfeviewWeb do
    pipe_through(:browser)

    live("/", BoardView)
  end

  # Other scopes may use custom stacks.
  # scope "/api", LfeviewWeb do
  #   pipe_through :api
  # end
end
