defmodule TemplatePhoenixApiWeb.NotificationChannel do
  use TemplatePhoenixApiWeb, :channel

  require Logger

  @impl true
  def join("notifications:" <> user_id, _payload, socket) do
    current_user = socket.assigns.current_user
    
    # Check if user is accessing their own notifications
    if to_string(current_user.id) == user_id do
      Logger.info("🔔 NotificationChannel subscribed for user: #{user_id}")
      {:ok, socket}
    else
      Logger.warning("🔔 Unauthorized notification channel access attempt for user: #{user_id}")
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def terminate(_reason, socket) do
    user = socket.assigns.current_user
    Logger.info("🔔 NotificationChannel unsubscribed for user: #{user.id}")
    :ok
  end
end