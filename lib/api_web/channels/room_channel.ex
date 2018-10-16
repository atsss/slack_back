defmodule ApiWeb.RoomChannel do
  use ApiWeb, :channel

  alias Api.Rooms

  def join("rooms:" <> room_id, _params, socket) do
    room = Rooms.get_room!(room_id)

    response = %{
      room: Phoenix.View.render_one(room, ApiWeb.RoomView, "room.json"),
    }

    {:ok, response, assign(socket, :room, room)}
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end
end
