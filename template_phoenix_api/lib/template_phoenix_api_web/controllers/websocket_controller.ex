defmodule TemplatePhoenixApiWeb.WebSocketController do
  use TemplatePhoenixApiWeb, :controller

  @doc """
  Provides information about the /cable WebSocket endpoint
  """
  def cable_info(conn, _params) do
    json(conn, %{
      endpoint: "/cable",
      type: "Phoenix WebSocket",
      protocol: "WebSocket",
      description: "ActionCable-compatible WebSocket endpoint for real-time chat, presence, and notifications",
      channels: %{
        "chat:*" => "Chat messages and typing indicators",
        "presence:*" => "User presence tracking", 
        "notifications:*" => "Real-time notification updates"
      },
      usage: %{
        connection: "Upgrade HTTP connection to WebSocket",
        authentication: "Provide JWT token in connection params",
        example: "ws://localhost:4000/cable?token=YOUR_JWT_TOKEN"
      },
      status: "Available"
    })
  end

  @doc """
  Provides information about the /graphql WebSocket endpoint
  """
  def graphql_info(conn, _params) do
    json(conn, %{
      endpoint: "/graphql",
      type: "GraphQL WebSocket",
      protocol: "WebSocket with GraphQL subscriptions",
      description: "GraphQL subscriptions over WebSocket for real-time data",
      subscriptions: %{
        "messageAdded" => "New chat messages in specific rooms",
        "notificationsUpdated" => "User notification updates"
      },
      usage: %{
        connection: "Upgrade HTTP connection to WebSocket with GraphQL protocol",
        authentication: "Provide JWT token in connection params",
        example: "ws://localhost:4000/graphql?token=YOUR_JWT_TOKEN"
      },
      status: "Available"
    })
  end
end