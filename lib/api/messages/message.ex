defmodule Api.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset


  schema "messages" do
    field :text, :string
    belongs_to :room, Api.Rooms.Room
    belongs_to :user, Api.Users.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
