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
    resources "/users", UserController, only: [:create]

    # FIXME: 後でやる
    # delete "/sessions", SessionController, :delete
  end

  scope "/api", ApiWeb do
    pipe_through [:api, :jwt_authenticated]

    post "/sessions/refresh", SessionController, :refresh
    get "/users/:id/rooms", UserController, :rooms
    resources "/rooms", RoomController, only: [:index, :create] do
      resources "/messages", MessageController, only: [:index]
    end
    post "/rooms/:id/join", RoomController, :join
  end
end
