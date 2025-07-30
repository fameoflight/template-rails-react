defmodule TemplatePhoenixApiWeb.PresenceChannel do
  use TemplatePhoenixApiWeb, :channel

  alias TemplatePhoenixApiWeb.Presence
  require Logger

  @impl true
  def join("presence:" <> room_id, _payload, socket) do
    Logger.info("👥 PresenceChannel joined for room: #{room_id}, user: #{socket.assigns.current_user.id}")
    
    send(self(), :after_join)
    {:ok, assign(socket, :room_id, room_id)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.current_user
    
    Logger.info("👤 Tracking presence for user #{user.name} in room: #{room_id}")
    
    # Track the user's presence
    {:ok, _} = Presence.track(socket, user.id, %{
      user: serialize_user(user),
      online_at: inspect(System.system_time(:second))
    })
    
    # Push current presence state to the user
    push(socket, "presence_state", Presence.list(socket))
    
    {:noreply, socket}
  end

  @impl true
  def handle_in("get_presence", _payload, socket) do
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    room_id = socket.assigns.room_id
    user = socket.assigns.current_user
    
    Logger.info("👥 PresenceChannel terminated for room: #{room_id}, user: #{user.id}")
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