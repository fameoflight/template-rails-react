defmodule TemplatePhoenixApiWeb.Plugs.ApiAuthPipeline do
  import Plug.Conn
  alias TemplatePhoenixApi.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        authenticate_with_token(conn, token)
      
      [] ->
        case get_req_header(conn, "authorization") do
          ["Token " <> token] ->
            authenticate_with_token(conn, token)
          
          _ ->
            unauthorized(conn)
        end
      
      _ ->
        unauthorized(conn)
    end
  end

  defp authenticate_with_token(conn, token) do
    case Accounts.get_api_access_token_by_token(token) do
      nil ->
        unauthorized(conn)
      
      api_token ->
        if TemplatePhoenixApi.Accounts.ApiAccessToken.active?(api_token) do
          user = TemplatePhoenixApi.Repo.preload(api_token, :user).user
          
          conn
          |> assign(:current_user, user)
          |> assign(:api_access_token, api_token)
        else
          unauthorized(conn)
        end
    end
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.json(%{error: %{message: "Bad credentials"}})
    |> halt()
  end
end