defmodule TemplatePhoenixApiWeb.Internal.MessagesController do
  use TemplatePhoenixApiWeb, :controller

  alias TemplatePhoenixApi.Content

  @doc """
  Lists messages for a specific room
  GET /api/internal/messages?room_id=room123&limit=50
  """
  def index(conn, params) do
    room_id = params["room_id"]
    limit = case params["limit"] do
      nil -> 50
      limit_str -> String.to_integer(limit_str)
    end

    messages = Content.list_messages_for_room(room_id, limit)

    json(conn, %{
      messages: Enum.map(messages, fn message ->
        %{
          id: to_string(message.id),
          content: message.content,
          createdAt: NaiveDateTime.to_iso8601(message.inserted_at),
          user: %{
            id: to_string(message.user.id),
            name: message.user.name || "Anonymous"
          }
        }
      end)
    })
  end

  def options(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-allow-methods", "GET, OPTIONS")
    |> put_resp_header("access-control-allow-headers", "authorization, content-type, accept, origin, user-agent, x-requested-with, access-token, token-type, client, expiry, uid, cache-control, pragma, if-modified-since, if-none-match, if-match, if-unmodified-since, if-range")
    |> send_resp(200, "")
  end
end