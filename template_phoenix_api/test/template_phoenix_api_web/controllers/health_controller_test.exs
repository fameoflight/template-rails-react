defmodule TemplatePhoenixApiWeb.HealthControllerTest do
  use TemplatePhoenixApiWeb.ConnCase

  describe "GET /health" do
    test "returns http success", %{conn: conn} do
      conn = get(conn, "/api/health")
      assert response(conn, 200)
    end
  end
end