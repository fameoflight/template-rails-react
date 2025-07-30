defmodule TemplatePhoenixApiWeb.Schema.Mutations.MessageCreateTest do
  use TemplatePhoenixApiWeb.ConnCase
  use TemplatePhoenixApiWeb.ChannelCase

  import TemplatePhoenixApi.Factory

  @create_message_mutation """
  mutation CreateMessage($input: MessageInput!) {
    createMessage(input: $input) {
      id
      content
      roomId
      user {
        id
        name
      }
    }
  }
  """

  describe "createMessage mutation" do
    test "creates message and broadcasts to channel subscribers" do
      user = insert(:user)
      room_id = "test-room"
      content = "Hello, world!"

      # Subscribe to the chat channel to listen for broadcasts
      token = TemplatePhoenixApi.Guardian.encode_and_sign(user) |> elem(1)
      {:ok, socket} = connect(TemplatePhoenixApiWeb.UserSocket, %{"token" => token})
      {:ok, _, _socket} = subscribe_and_join(socket, "chat:#{room_id}", %{})

      # Execute the GraphQL mutation
      conn = build_conn()
      
      context = %{current_user: user}
      
      result = Absinthe.run(@create_message_mutation, 
        TemplatePhoenixApiWeb.Schema, 
        variables: %{
          "input" => %{
            "content" => content,
            "roomId" => room_id
          }
        },
        context: context
      )

      # Check GraphQL response
      assert {:ok, %{data: %{"createMessage" => message_data}}} = result
      assert message_data["content"] == content
      assert message_data["user"]["id"] == to_string(user.id)

      # Check that message was broadcasted to the channel
      assert_broadcast "message_added", %{
        type: "message_added", 
        message: broadcasted_message
      }
      
      assert broadcasted_message["content"] == content
      assert broadcasted_message["user"]["id"] == to_string(user.id)
    end

    test "returns error when user is not authenticated" do
      room_id = "test-room"
      content = "Hello, world!"

      conn = build_conn()
      
      # No context provided (no user)
      result = Absinthe.run(@create_message_mutation, 
        TemplatePhoenixApiWeb.Schema, 
        variables: %{
          "input" => %{
            "content" => content,
            "roomId" => room_id
          }
        }
      )

      # Should return error
      assert {:ok, %{errors: [%{message: error_message}]}} = result
      assert error_message == "You must be signed in to send messages"
    end

    test "validates message content" do
      user = insert(:user)
      room_id = "test-room"

      conn = build_conn()
      
      context = %{current_user: user}
      
      result = Absinthe.run(@create_message_mutation, 
        TemplatePhoenixApiWeb.Schema, 
        variables: %{
          "input" => %{
            "content" => "",  # Empty content
            "roomId" => room_id
          }
        },
        context: context
      )

      # Should return validation error
      assert {:ok, %{errors: [%{message: error_message}]}} = result
      assert String.contains?(error_message, "content")
    end
  end
end