defmodule TemplatePhoenixApiWeb.HealthController do
  use TemplatePhoenixApiWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{status: "ok", timestamp: DateTime.utc_now()})
  end
end