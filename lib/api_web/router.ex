defmodule ApiWeb.Router do
  use ApiWeb, :router

  alias Api.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", ApiWeb do
    pipe_through [:api]

    post "/sessions", SessionController, :create
    post "/sessions/refresh", SessionController, :refresh
    resources "/users", UserController, only: [:create]

    # FIXME: 後でやる
    # delete "/sessions", SessionController, :delete
  end

  scope "/api", ApiWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my_user", UserController, :show
  end
end
