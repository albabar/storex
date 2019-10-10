defmodule StorexWeb.Router do
  use StorexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug StorexWeb.Plugs.FetchCart
    plug StorexWeb.Plugs.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StorexWeb do
    pipe_through :browser

#    get "/", PageController, :index
    get "/", BookController, :index
    get "/books/:id", BookController, :show
    resources "/cart", CartController, singleton: true, only: [:show, :create, :delete]
    resources "/user", UserController, only: [:new, :create]
    resources "/session", SessionController, singleton: true, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", StorexWeb do
  #   pipe_through :api
  # end
end
