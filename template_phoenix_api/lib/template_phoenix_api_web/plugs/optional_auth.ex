defmodule TemplatePhoenixApiWeb.Plugs.OptionalAuth do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # Try DeviseTokenAuth style first (access-token header)
    case get_req_header(conn, "access-token") do
      [token] when token != "" ->
        case TemplatePhoenixApi.Guardian.decode_token(token) do
          {:ok, user, _claims} -> assign(conn, :current_user, user)
          _ -> try_bearer_auth(conn)
        end
      _ ->
        try_bearer_auth(conn)
    end
  end

  defp try_bearer_auth(conn) do
    # Try Bearer token style (authorization header)
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- TemplatePhoenixApi.Guardian.decode_token(token) do
      assign(conn, :current_user, user)
    else
      _ -> conn
    end
  end
end