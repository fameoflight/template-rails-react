defmodule TemplatePhoenixApi.Services.BroadcastService do
  @moduledoc """
  Service for broadcasting messages to Phoenix channels.
  Equivalent to Rails ActionCable broadcasting.
  """

  require Logger
  alias TemplatePhoenixApiWeb.Endpoint

  @doc """
  Broadcast a chat message to all subscribers of a room.
  """
  def broadcast_message(room_id, message) do
    Logger.info("📡 Broadcasting chat message to room: #{room_id}")
    
    message_data = serialize_message(message)
    
    # Phoenix Channel broadcast (like Rails ActionCable)
    Endpoint.broadcast("chat:#{room_id}", "message_added", %{
      type: "message_added",
      message: message_data
    })
    
    # GraphQL subscription trigger (like Rails) - only if endpoint is running
    try do
      Absinthe.Subscription.publish(
        Endpoint,
        message,
        message_added: "message_added:#{room_id}"
      )
    rescue
      ArgumentError -> 
        Logger.warning("📡 Skipping GraphQL subscription (endpoint not running)")
    end
  end

  @doc """
  Broadcast typing indicator to room subscribers.
  """
  def broadcast_typing(room_id, user, is_typing \\ true) do
    action = if is_typing, do: "started", else: "stopped"
    Logger.info("📡 Broadcasting typing indicator: #{user.name} #{action} typing in #{room_id}")
    
    Endpoint.broadcast("chat:#{room_id}", "typing_update", %{
      type: "typing_update",
      user: serialize_user(user),
      is_typing: is_typing
    })
  end

  @doc """
  Broadcast user joined to presence subscribers.
  """
  def broadcast_user_joined(room_id, user) do
    Logger.info("📡 Broadcasting user joined: #{user.name} joined #{room_id}")
    
    Endpoint.broadcast("presence:#{room_id}", "user_joined", %{
      type: "user_joined",
      user: serialize_user(user)
    })
  end

  @doc """
  Broadcast user left to presence subscribers.
  """
  def broadcast_user_left(room_id, user) do
    Logger.info("📡 Broadcasting user left: #{user.name} left #{room_id}")
    
    Endpoint.broadcast("presence:#{room_id}", "user_left", %{
      type: "user_left",
      user: serialize_user(user)
    })
  end

  @doc """
  Broadcast presence update to room subscribers.
  """
  def broadcast_presence_update(room_id, online_users) do
    Logger.info("📡 Broadcasting presence update for room: #{room_id} (#{length(online_users)} users)")
    
    Endpoint.broadcast("presence:#{room_id}", "presence_update", %{
      type: "presence_update",
      users: Enum.map(online_users, &serialize_user/1)
    })
  end

  @doc """
  Broadcast notification to user.
  """
  def broadcast_notification(user_id, notification) do
    Logger.info("📡 Broadcasting notification to user: #{user_id}")
    
    # Phoenix Channel broadcast (like Rails ActionCable)
    Endpoint.broadcast("notifications_#{user_id}", "notification", %{
      type: "notification",
      notification: serialize_notification(notification)
    })
    
    # GraphQL subscription trigger (like Rails) - only if endpoint is running
    try do
      Absinthe.Subscription.publish(
        Endpoint,
        notification,
        notifications_updated: "notifications_updated:#{user_id}"
      )
    rescue
      ArgumentError -> 
        Logger.warning("📡 Skipping GraphQL subscription (endpoint not running)")
    end
  end

  @doc """
  Broadcast notification count update to user.
  """
  def broadcast_notification_count_update(user_id, unread_count) do
    Logger.info("📡 Broadcasting notification count update to user: #{user_id} (#{unread_count} unread)")
    
    Endpoint.broadcast("notifications_#{user_id}", "unread_count_update", %{
      type: "unread_count_update",
      unread_count: unread_count
    })
  end

  @doc """
  Helper to create and broadcast notification.
  """
  def create_and_broadcast_notification(user, title, message, notification_type \\ "system", data \\ %{}) do
    case TemplatePhoenixApi.Content.create_notification(%{
      user_id: user.id,
      title: title,
      message: message,
      notification_type: notification_type,
      data: data
    }) do
      {:ok, notification} ->
        # Reload with user association
        notification = TemplatePhoenixApi.Content.get_notification!(notification.id)
        broadcast_notification(user.id, notification)
        {:ok, notification}
        
      error ->
        error
    end
  end

  @doc """
  Broadcast system message to room subscribers.
  """
  def broadcast_system_message(room_id, message, level \\ "info") do
    Logger.info("📡 Broadcasting system message to room: #{room_id}")
    
    Endpoint.broadcast("chat:#{room_id}", "system_message", %{
      type: "system_message",
      message: message,
      level: level,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  @doc """
  Broadcast live update to a specific channel.
  """
  def broadcast_live_update(channel, data) do
    Logger.info("📡 Broadcasting live update to: #{channel}")
    
    Endpoint.broadcast(channel, "live_update", %{
      type: "live_update",
      data: data,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  # Private helper functions

  defp serialize_message(message) do
    %{
      id: to_string(message.id),
      content: message.content,
      createdAt: NaiveDateTime.to_iso8601(message.inserted_at),
      user: serialize_user(message.user)
    }
  end

  defp serialize_user(user) do
    %{
      id: to_string(user.id),
      name: user.name,
      email: user.email
    }
  end

  defp serialize_notification(notification) do
    %{
      id: to_string(notification.id),
      title: notification.title,
      message: notification.message,
      type: notification.notification_type,
      read: TemplatePhoenixApi.Content.Notification.read?(notification),
      createdAt: NaiveDateTime.to_iso8601(notification.inserted_at)
    }
  end
end