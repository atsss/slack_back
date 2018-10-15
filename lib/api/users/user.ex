defmodule Api.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]


  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string
    field :password, :string, virtual: true
    many_to_many :rooms, Api.Rooms.Room, join_through: "user_rooms"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:username)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
