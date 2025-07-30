defmodule TemplatePhoenixApiWeb.Schema.Types.Notification do
  use TemplatePhoenixApiWeb.Schema.BaseObject

  alias TemplatePhoenixApi.Content.Notification

  @desc "A notification"
  object :notification do
    # Standard fields (id, created_at, updated_at, model_id)
    standard_fields()
    
    # Notification-specific fields
    field :title, non_null(:string)
    field :message, non_null(:string)
    field :notification_type, non_null(:string)
    field :read_at, :iso8601_datetime do
      resolve fn notification, _args, _context ->
        case notification.read_at do
          nil -> {:ok, nil}
          naive_datetime -> {:ok, DateTime.from_naive!(naive_datetime, "Etc/UTC")}
        end
      end
    end
    field :data, :json
    
    field :user, non_null(:user) do
      resolve fn notification, _args, _context ->
        case notification.user do
          %Ecto.Association.NotLoaded{} -> {:error, "User not loaded"}
          user -> {:ok, user}
        end
      end
    end

    field :read, non_null(:boolean) do
      resolve fn notification, _args, _context ->
        {:ok, Notification.read?(notification)}
      end
    end

    field :icon, non_null(:string) do
      resolve fn notification, _args, _context ->
        {:ok, Notification.icon(notification.notification_type)}
      end
    end

    field :color, non_null(:string) do
      resolve fn notification, _args, _context ->
        {:ok, Notification.color(notification.notification_type)}
      end
    end
  end

  @desc "Connection for notifications"
  object :notification_connection do
    field :edges, list_of(:notification_edge)
    field :page_info, non_null(:page_info)
  end

  @desc "Edge for notification connection"
  object :notification_edge do
    field :node, :notification
    field :cursor, non_null(:string)
  end

  @desc "Page info for connections"
  object :page_info do
    field :has_next_page, non_null(:boolean)
    field :has_previous_page, non_null(:boolean)
    field :start_cursor, :string
    field :end_cursor, :string
  end

  @desc "Input for marking a notification as read"
  input_object :notification_mark_as_read_input do
    field :notification_id, non_null(:id)
  end

  @desc "Input for marking all notifications as read"
  input_object :notification_mark_all_as_read_input do
    field :confirm, :boolean, default_value: true
  end

  @desc "Response for marking a notification as read"
  object :notification_mark_as_read_response do
    field :notification, :notification
    field :unread_count, non_null(:integer)
    field :errors, list_of(:string)
  end

  @desc "Response for marking all notifications as read"
  object :notification_mark_all_as_read_response do
    field :success, non_null(:boolean)
    field :unread_count, non_null(:integer)
    field :errors, list_of(:string)
  end
end