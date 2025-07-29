defmodule TemplatePhoenixApiWeb.Middleware.AuthMiddleware do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _user} ->
        resolution
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Authentication required"})
    end
  end
end