defmodule TemplatePhoenixApiWeb.GraphqlController do
  use TemplatePhoenixApiWeb, :controller

  def execute(conn, _params) do
    context = build_context(conn)
    
    # Check if client accepts MessagePack
    accepts_msgpack = accepts_msgpack?(conn)
    
    if accepts_msgpack do
      # Execute GraphQL and return MessagePack response
      execute_graphql_msgpack(conn, context)
    else
      # Use default Absinthe.Plug for JSON response
      Absinthe.Plug.call(conn, Absinthe.Plug.init(
        schema: TemplatePhoenixApiWeb.Schema,
        context: context
      ))
    end
  end

  def options(conn, _params) do
    # Handle CORS preflight requests
    conn
    |> put_status(200)
    |> json(%{})
  end

  defp build_context(conn) do
    case conn.assigns[:current_user] do
      nil -> %{}
      user -> %{current_user: user}
    end
  end

  defp accepts_msgpack?(conn) do
    case get_req_header(conn, "accept") do
      [accept_header | _] ->
        String.contains?(accept_header, "application/msgpack")
      _ ->
        false
    end
  end

  defp execute_graphql_msgpack(conn, context) do
    # Extract GraphQL query, variables, and operation name
    query = conn.body_params["query"] || conn.params["query"]
    variables = conn.body_params["variables"] || conn.params["variables"] || %{}
    operation_name = conn.body_params["operationName"] || conn.params["operationName"]

    # Execute the GraphQL query
    case Absinthe.run(query, TemplatePhoenixApiWeb.Schema, 
         context: context, 
         variables: variables, 
         operation_name: operation_name) do
      {:ok, result} ->
        send_msgpack_response(conn, result)
      {:error, _error} ->
        send_msgpack_response(conn, %{errors: [%{message: "GraphQL execution error"}]})
    end
  end

  defp send_msgpack_response(conn, data) do
    case Msgpax.pack(data) do
      {:ok, msgpack_data} ->
        conn
        |> put_resp_content_type("application/msgpack")
        |> send_resp(200, msgpack_data)
      {:error, _} ->
        conn
        |> put_status(500)
        |> json(%{errors: [%{message: "Failed to encode response as MessagePack"}]})
    end
  end
end