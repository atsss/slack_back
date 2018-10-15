defmodule ApiWeb.RoomController do
  use ApiWeb, :controller

  alias Api.Rooms
  alias Api.Rooms.Room
  alias Api.UserRooms
  alias Api.UserRooms.UserRoom
  alias Api.Guardian

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, room_params) do
    current_user = Guardian.Plug.current_resource(conn)

    with {:ok, %Room{} = room} <- Rooms.create_room(room_params) do
      UserRooms.create_user_room(%{user_id: current_user.id, room_id: room.id})
      conn |> render("show.json", room: room)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    room = Rooms.get_room!(room_id)

    with {:ok, %UserRoom{} = _user_room} <- UserRooms.create_user_room(%{user_id: current_user.id, room_id: room.id}) do
      conn |> render("show.json", room: room)
    end
  end
end
