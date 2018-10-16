defmodule ApiWeb.RoomChannel do
  use ApiWeb, :channel
  import Ecto, only: [build_assoc: 3]

  alias Api.Rooms
  alias Api.Messages
  alias Api.Messages.Message

  def join("rooms:" <> room_id, _params, socket) do
    room = Rooms.get_room!(room_id)
    page = Messages.list_messages_for(room.id)

    response = %{
      room: Phoenix.View.render_one(room, ApiWeb.RoomView, "room.json"),
      messages: Phoenix.View.render_many(page.entries, ApiWeb.MessageView, "message.json"),
      pagination: ApiWeb.PaginationHelpers.pagination(page)
    }

    {:ok, response, assign(socket, :room, room)}
  end

  def handle_in("new_message", params, socket) do
    changeset =
      socket.assigns.room
      |> build_assoc(:messages, user_id: socket.assigns.guardian_default_resource.id)
      |> Message.changeset(params)

    case Api.Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, Phoenix.View.render(ApiWeb.ChangesetView, "error.json", changeset: changeset)}, socket}
    end

    # with {:ok, %Message{} = message} <- socket.assigns.room
    #                                     |> build_assoc(:messages, user_id: socket.assigns.guardian_default_resource.id)
    #                                     |> Messages.create_message(params) do
    #   broadcast_message(socket, message)
    #   {:reply, :ok, socket}
    # end
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end

  defp broadcast_message(socket, message) do
    message = Api.Repo.preload(message, :user)
    rendered_message = Phoenix.View.render_one(message, ApiWeb.MessageView, "message.json")
    broadcast!(socket, "message_created", rendered_message)
  end
end
