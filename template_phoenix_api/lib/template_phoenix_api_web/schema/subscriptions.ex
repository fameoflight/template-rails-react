defmodule TemplatePhoenixApiWeb.Schema.Subscriptions do
  use Absinthe.Schema.Notation

  require Logger

  object :subscriptions do
    @desc "A message was added to a chat room"
    field :message_added, :message do
      arg :room_id, non_null(:string)
      
      config fn %{room_id: room_id}, %{context: %{current_user: current_user}} ->
        Logger.info("🔔 Subscription setup - message_added for room: #{room_id}, user: #{current_user.id}")
        {:ok, topic: "message_added:#{room_id}"}
      end
      
      config fn _args, _context ->
        {:error, "You must be signed in to subscribe to messages"}
      end
      
      resolve fn %{room_id: room_id}, %{source: message}, _context ->
        Logger.info("🔔 Subscription resolver - message: #{message && message.id}, room_id: #{message && message.room_id}, requested_room: #{room_id}")
        Logger.info("🔍 Message object class: #{message.__struct__}, inspect: #{inspect(message)}")
        
        # Only return the message if it matches the requested room
        case message do
          nil -> 
            Logger.info("❌ No message received")
            {:ok, nil}
          %{room_id: ^room_id} ->
            Logger.info("✅ Message matches room, returning: #{message.id}")
            Logger.info("🔍 Message attributes: id=#{message.id}, content=#{message.content}, user_id=#{message.user_id}")
            {:ok, message}
          _ ->
            Logger.info("❌ Message room_id #{message.room_id} doesn't match requested room #{room_id}")
            {:ok, nil}
        end
      end
    end

    @desc "User received a new notification or notification count changed"
    field :notifications_updated, :notification do
      config fn _args, %{context: %{current_user: current_user}} ->
        Logger.info("🔔 Subscription setup - notifications_updated for user: #{current_user.id}")
        {:ok, topic: "notifications_updated:#{current_user.id}"}
      end
      
      config fn _args, _context ->
        {:error, "You must be signed in to subscribe to notifications"}
      end
      
      resolve fn _args, %{source: notification}, _context ->
        Logger.info("🔔 Notifications subscription resolver - notification: #{notification && notification.id}")
        # This will be triggered when a new notification is created
        # or when notification count changes
        {:ok, notification}
      end
    end
  end
end