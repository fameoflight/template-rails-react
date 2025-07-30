defmodule TemplatePhoenixApiWeb.Schema.Mutations.NotificationMutations do
  use Absinthe.Schema.Notation

  alias TemplatePhoenixApi.Content
  alias TemplatePhoenixApiWeb.Schema

  object :notification_mutations do
    @desc "Mark a notification as read"
    field :notification_mark_as_read, :notification_mark_as_read_response do
      arg :input, non_null(:notification_mark_as_read_input)
      
      resolve fn %{input: %{notification_id: notification_id}}, %{context: %{current_user: current_user}} ->
        case Schema.object_from_id(notification_id, nil) do
          %TemplatePhoenixApi.Content.Notification{} = notification ->
            # Check if user owns this notification
            if notification.user_id == current_user.id do
              case Content.mark_notification_as_read(notification) do
                {:ok, updated_notification} ->
                  # Reload with user association
                  updated_notification = Content.get_notification!(updated_notification.id)
                  
                  # Broadcast notification count update
                  new_count = Content.get_unread_notification_count(current_user.id)
                  TemplatePhoenixApi.Services.BroadcastService.broadcast_notification_count_update(
                    current_user.id, 
                    new_count
                  )
                  
                  {:ok, %{
                    notification: updated_notification,
                    unread_count: new_count,
                    errors: []
                  }}
                  
                {:error, changeset} ->
                  errors = Enum.map(changeset.errors, fn {field, {message, _}} ->
                    "#{field}: #{message}"
                  end)
                  
                  {:ok, %{
                    notification: nil,
                    unread_count: Content.get_unread_notification_count(current_user.id),
                    errors: errors
                  }}
              end
            else
              {:ok, %{
                notification: nil,
                unread_count: Content.get_unread_notification_count(current_user.id),
                errors: ["You don't have permission to mark this notification as read"]
              }}
            end
            
          _ ->
            {:ok, %{
              notification: nil,
              unread_count: Content.get_unread_notification_count(current_user.id),
              errors: ["Notification not found"]
            }}
        end
      end
      
      resolve fn _args, _context ->
        {:error, "You must be signed in to mark notifications as read"}
      end
    end

    @desc "Mark all notifications as read"
    field :notification_mark_all_as_read, :notification_mark_all_as_read_response do
      arg :input, non_null(:notification_mark_all_as_read_input)
      
      resolve fn %{input: _input}, %{context: %{current_user: current_user}} ->
        case Content.mark_all_notifications_as_read(current_user.id) do
          {count, _} when count > 0 ->
            # Broadcast notification count update (should now be 0)
            TemplatePhoenixApi.Services.BroadcastService.broadcast_notification_count_update(
              current_user.id, 
              0
            )
            {:ok, %{
              success: true,
              unread_count: 0,
              errors: []
            }}
            
          _ ->
            {:ok, %{
              success: true,
              unread_count: 0,
              errors: []
            }}
        end
      end
      
      resolve fn _args, _context ->
        {:error, "You must be signed in to mark notifications as read"}
      end
    end
  end
end