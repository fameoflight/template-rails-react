defmodule TemplatePhoenixApiWeb.ChatChannel do
  use TemplatePhoenixApiWeb, :channel

  require Logger

  @impl true
  def join("chat:" <> room_id, _payload, socket) do
    Logger.info("🎯 ChatChannel joined for room: #{room_id}, user: #{socket.assigns.current_user.id}")
    
    send(self(), :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.current_user
    
    Logger.info("👤 User #{user.name} joined chat room: #{room_id}")
    
    # Broadcast user joined to presence channel
    TemplatePhoenixApiWeb.Endpoint.broadcast("presence:#{room_id}", "user_joined", %{
      user: serialize_user(user)
    })
    
    {:noreply, socket}
  end


  # Handle typing indicators (matching Rails ActionCable behavior)
  @impl true
  def handle_in("start_typing", _data, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.current_user
    
    Logger.info("⌨️ #{user.name} started typing in room: #{room_id}")
    
    # Use BroadcastService like Rails does
    TemplatePhoenixApi.Services.BroadcastService.broadcast_typing(room_id, user, true)
    
    {:noreply, socket}
  end

  @impl true
  def handle_in("stop_typing", _data, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.current_user
    
    Logger.info("⌨️ #{user.name} stopped typing in room: #{room_id}")
    
    # Use BroadcastService like Rails does
    TemplatePhoenixApi.Services.BroadcastService.broadcast_typing(room_id, user, false)
    
    {:noreply, socket}
  end


  @impl true
  def terminate(_reason, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.current_user
    
    Logger.info("🎯 ChatChannel unsubscribed from room: #{room_id}")
    
    # Clear typing indicator when user disconnects (matching Rails behavior)
    TemplatePhoenixApi.Services.BroadcastService.broadcast_typing(room_id, user, false)
    
    :ok
  end

  defp serialize_user(user) do
    %{
      id: to_string(user.id),
      name: user.name,
      email: user.email
    }
  end
end