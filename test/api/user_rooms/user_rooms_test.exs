defmodule Api.UserRoomsTest do
  use Api.DataCase

  alias Api.UserRooms

  describe "user_rooms" do
    alias Api.UserRooms.UserRoom

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def user_room_fixture(attrs \\ %{}) do
      {:ok, user_room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserRooms.create_user_room()

      user_room
    end

    test "list_user_rooms/0 returns all user_rooms" do
      user_room = user_room_fixture()
      assert UserRooms.list_user_rooms() == [user_room]
    end

    test "get_user_room!/1 returns the user_room with given id" do
      user_room = user_room_fixture()
      assert UserRooms.get_user_room!(user_room.id) == user_room
    end

    test "create_user_room/1 with valid data creates a user_room" do
      assert {:ok, %UserRoom{} = user_room} = UserRooms.create_user_room(@valid_attrs)
    end

    test "create_user_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRooms.create_user_room(@invalid_attrs)
    end

    test "update_user_room/2 with valid data updates the user_room" do
      user_room = user_room_fixture()
      assert {:ok, user_room} = UserRooms.update_user_room(user_room, @update_attrs)
      assert %UserRoom{} = user_room
    end

    test "update_user_room/2 with invalid data returns error changeset" do
      user_room = user_room_fixture()
      assert {:error, %Ecto.Changeset{}} = UserRooms.update_user_room(user_room, @invalid_attrs)
      assert user_room == UserRooms.get_user_room!(user_room.id)
    end

    test "delete_user_room/1 deletes the user_room" do
      user_room = user_room_fixture()
      assert {:ok, %UserRoom{}} = UserRooms.delete_user_room(user_room)
      assert_raise Ecto.NoResultsError, fn -> UserRooms.get_user_room!(user_room.id) end
    end

    test "change_user_room/1 returns a user_room changeset" do
      user_room = user_room_fixture()
      assert %Ecto.Changeset{} = UserRooms.change_user_room(user_room)
    end
  end
end
