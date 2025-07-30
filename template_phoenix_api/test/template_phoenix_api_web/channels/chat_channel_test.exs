defmodule TemplatePhoenixApiWeb.ChatChannelTest do
  use TemplatePhoenixApiWeb.ChannelCase

  import TemplatePhoenixApi.Factory

  setup do
    user = insert(:user)
    token = TemplatePhoenixApi.Guardian.encode_and_sign(user) |> elem(1)
    
    {:ok, socket} = connect(TemplatePhoenixApiWeb.UserSocket, %{"token" => token})
    
    {:ok, socket: socket, user: user}
  end

  describe "joining chat channel" do
    test "succeeds with valid room_id", %{socket: socket, user: user} do
      {:ok, _, socket} = subscribe_and_join(socket, "chat:test-room", %{})
      
      assert socket.assigns.room_id == "test-room"
      assert socket.assigns.current_user.id == user.id
    end
  end

  describe "typing indicators" do
    test "broadcasts start_typing to other users", %{socket: socket} do
      {:ok, _, socket} = subscribe_and_join(socket, "chat:test-room", %{})
      
      ref = push(socket, "start_typing", %{})
      assert_reply ref, :ok
      
      # Should broadcast to other users in the room
      assert_broadcast "typing_update", %{user: user_data, is_typing: true}
      assert user_data["id"] == to_string(socket.assigns.current_user.id)
    end

    test "broadcasts stop_typing to other users", %{socket: socket} do
      {:ok, _, socket} = subscribe_and_join(socket, "chat:test-room", %{})
      
      ref = push(socket, "stop_typing", %{})
      assert_reply ref, :ok
      
      # Should broadcast to other users in the room
      assert_broadcast "typing_update", %{user: user_data, is_typing: false}
      assert user_data["id"] == to_string(socket.assigns.current_user.id)
    end
  end

  describe "disconnect" do
    test "clears typing indicator on disconnect", %{socket: socket} do
      {:ok, _, socket} = subscribe_and_join(socket, "chat:test-room", %{})
      
      # Simulate disconnect
      close(socket)
      
      # Should broadcast typing indicator off
      assert_broadcast "typing_update", %{user: user_data, is_typing: false}
      assert user_data["id"] == to_string(socket.assigns.current_user.id)
    end
  end
end