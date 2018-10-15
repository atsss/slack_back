defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.Users
  alias Api.Users.User
  alias Api.Rooms
  alias Api.Guardian

  action_fallback ApiWeb.FallbackController

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn |> render(ApiWeb.SessionView, "show.json", user: user, jwt: token)
    end
  end

  def rooms(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    rooms = Rooms.list_rooms_of(current_user)
    render(ApiWeb.RoomView, "index.json", rooms: rooms)
  end


  # def index(conn, _params) do
  #   users = Users.list_users()
  #   render(conn, "index.json", users: users)
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   user = Users.get_user!(id)
  #   render(conn, "show.json", user: user)
  # end
  #
  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Users.get_user!(id)
  #
  #   with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   user = Users.get_user!(id)
  #   with {:ok, %User{}} <- Users.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
