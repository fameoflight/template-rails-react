defmodule TemplatePhoenixApiWeb.Schema.Queries.NotificationQueries do
  use Absinthe.Schema.Notation

  alias TemplatePhoenixApi.Content

  object :notification_queries do
    @desc "Get notifications for the current user"
    field :notifications, :notification_connection do
      arg :first, :integer, default_value: 10
      arg :after, :string
      
      resolve fn args, context ->
        case context do
          %{context: %{current_user: current_user}} ->
            %{first: limit} = args
            notifications = Content.list_notifications_for_user(current_user.id, limit)
            
            edges = Enum.map(notifications, fn notification ->
              %{
                node: notification,
                cursor: Base.encode64("notification:#{notification.id}")
              }
            end)
            
            {:ok, %{
              edges: edges,
              page_info: %{
                has_next_page: length(edges) == limit,
                has_previous_page: false,
                start_cursor: (if length(edges) > 0, do: List.first(edges).cursor, else: nil),
                end_cursor: (if length(edges) > 0, do: List.last(edges).cursor, else: nil)
              }
            }}
          _ ->
            {:error, "You must be signed in to view notifications"}
        end
      end
    end

    @desc "Get unread notification count for the current user"
    field :unread_notification_count, :integer do
      resolve fn _args, context ->
        case context do
          %{context: %{current_user: current_user}} ->
            count = Content.get_unread_notification_count(current_user.id)
            {:ok, count}
          _ ->
            {:error, "You must be signed in to view notification count"}
        end
      end
    end
  end
end