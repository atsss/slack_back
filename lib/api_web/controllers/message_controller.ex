defmodule ApiWeb.MessageController do
  use ApiWeb, :controller

  alias Api.Rooms
  alias Api.Messages

  def index(conn, params) do
    last_seen_id = params["last_seen_id"] || 0
    room = Rooms.get_room!(params["room_id"])

    page = Messages.list_messages_of(room.id, last_seen_id)

    render(conn, "index.json", %{messages: page.entries, pagination: ApiWeb.PaginationHelpers.pagination(page)})
  end
end
