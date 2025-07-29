defmodule TemplatePhoenixApiWeb.Plugs.MsgpackParser do
  def init(opts), do: opts

  def call(conn, _opts) do
    case get_content_type(conn) do
      "application/msgpack" ->
        parse_msgpack_body(conn)
      _ ->
        conn
    end
  end

  defp get_content_type(conn) do
    case Plug.Conn.get_req_header(conn, "content-type") do
      [content_type | _] ->
        content_type
        |> String.split(";")
        |> List.first()
        |> String.trim()
      _ ->
        nil
    end
  end

  defp parse_msgpack_body(conn) do
    case Plug.Conn.read_body(conn) do
      {:ok, body, conn} ->
        case Msgpax.unpack(body) do
          {:ok, params} ->
            %{conn | body_params: params, params: Map.merge(conn.params, params)}
          {:error, _} ->
            conn
        end
      {:more, _partial_body, conn} ->
        # Handle case where body is too large
        conn
      {:error, _reason} ->
        conn
    end
  end
end