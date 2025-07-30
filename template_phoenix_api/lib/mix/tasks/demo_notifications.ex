defmodule Mix.Tasks.Demo.Notifications do
  @moduledoc """
  Create demo notifications for testing
  
  Usage: mix demo.notifications
  """
  
  use Mix.Task
  require Logger

  alias TemplatePhoenixApi.Accounts
  alias TemplatePhoenixApi.Content
  alias TemplatePhoenixApi.Services.BroadcastService

  @shortdoc "Create demo notifications for testing"

  def run(_args) do
    Mix.Task.run("app.start")
    
    Logger.info("Creating demo notifications...")
    
    # Get the first user, or create one if none exists
    case Accounts.list_users() |> List.first() do
      nil ->
        Logger.error("No users found. Please create a user first.")
        System.halt(1)
      
      user ->
        Logger.info("Creating notifications for user: #{user.email}")
        create_demo_notifications(user)
    end
  end

  defp create_demo_notifications(user) do
    # Create various types of notifications
    notifications = [
      %{
        title: "Welcome to the platform!",
        message: "Thanks for joining us. Explore all the features we have to offer.",
        notification_type: "success"
      },
      %{
        title: "New message received",
        message: "You have a new message in the chat room 'General'.",
        notification_type: "message"
      },
      %{
        title: "System maintenance scheduled",
        message: "We'll be performing maintenance tonight from 2-4 AM EST.",
        notification_type: "warning"
      },
      %{
        title: "Profile updated successfully",
        message: "Your profile information has been updated.",
        notification_type: "success"
      },
      %{
        title: "Security alert",
        message: "New login detected from a different device.",
        notification_type: "warning"
      },
      %{
        title: "Achievement unlocked!",
        message: "You've sent your first message. Keep it up!",
        notification_type: "achievement"
      },
      %{
        title: "Reminder: Complete your profile",
        message: "Don't forget to add your profile picture and bio.",
        notification_type: "reminder"
      },
      %{
        title: "Connection error resolved",
        message: "The network connection issue has been resolved.",
        notification_type: "success"
      }
    ]
    
    notifications
    |> Enum.with_index()
    |> Enum.each(fn {notif, index} ->
      case BroadcastService.create_and_broadcast_notification(
        user,
        notif.title,
        notif.message,
        notif.notification_type
      ) do
        {:ok, notification} ->
          # Mark some as read for variety
          if rem(index, 2) == 0 do
            Content.mark_notification_as_read(notification)
          end
          
          Logger.info("Created: #{notif.title}")
          
        {:error, error} ->
          Logger.error("Failed to create notification: #{inspect(error)}")
      end
      
      # Add some delay to make created_at times different
      Process.sleep(100)
    end)
    
    # Get updated counts
    unread_count = Content.get_unread_notification_count(user.id)
    total_count = Content.list_notifications_for_user(user.id) |> length()
    
    Logger.info("Demo notifications created successfully!")
    Logger.info("Unread count: #{unread_count}")
    Logger.info("Total count: #{total_count}")
  end
end