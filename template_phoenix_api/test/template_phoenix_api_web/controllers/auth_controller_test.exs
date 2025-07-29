defmodule TemplatePhoenixApiWeb.AuthControllerTest do
  use TemplatePhoenixApiWeb.ConnCase

  describe "POST /api/auth/register" do
    test "creates user and returns auth token", %{conn: conn} do
      user_params = %{
        user: %{
          name: "Test User",
          email: "test@example.com",
          password: "password123"
        }
      }

      conn = post(conn, "/api/auth/register", user_params)

      assert %{
        "data" => %{
          "user" => user_data,
          "token" => token
        }
      } = json_response(conn, 201)

      assert user_data["email"] == "test@example.com"
      assert user_data["name"] == "Test User"
      assert user_data["confirmed"] == false
      assert is_binary(token)
    end

    test "returns errors for invalid data", %{conn: conn} do
      user_params = %{
        user: %{
          email: "invalid-email",
          password: "short"
        }
      }

      conn = post(conn, "/api/auth/register", user_params)

      assert %{
        "errors" => errors
      } = json_response(conn, 422)

      assert Map.has_key?(errors, "name")
      assert Map.has_key?(errors, "email")
      assert Map.has_key?(errors, "password")
    end

    test "returns error for duplicate email", %{conn: conn} do
      insert(:user, email: "test@example.com")

      user_params = %{
        user: %{
          name: "Test User",
          email: "test@example.com",
          password: "password123"
        }
      }

      conn = post(conn, "/api/auth/register", user_params)

      assert %{
        "errors" => %{
          "email" => ["has already been taken"]
        }
      } = json_response(conn, 422)
    end
  end

  describe "POST /api/auth/login" do
    test "returns auth token for valid credentials", %{conn: conn} do
      user = insert(:user, email: "test@example.com")

      login_params = %{
        email: "test@example.com",
        password: "password123"
      }

      conn = post(conn, "/api/auth/login", login_params)

      assert %{
        "data" => %{
          "user" => user_data,
          "token" => token
        }
      } = json_response(conn, 200)

      assert user_data["id"] == user.id
      assert user_data["email"] == "test@example.com"
      assert is_binary(token)
    end

    test "returns error for invalid credentials", %{conn: conn} do
      insert(:user, email: "test@example.com")

      login_params = %{
        email: "test@example.com",
        password: "wrongpassword"
      }

      conn = post(conn, "/api/auth/login", login_params)

      assert %{
        "error" => %{
          "message" => "Invalid email or password"
        }
      } = json_response(conn, 401)
    end

    test "returns error for non-existent user", %{conn: conn} do
      login_params = %{
        email: "nonexistent@example.com",
        password: "password123"
      }

      conn = post(conn, "/api/auth/login", login_params)

      assert %{
        "error" => %{
          "message" => "Invalid email or password"
        }
      } = json_response(conn, 401)
    end
  end

  describe "GET /api/auth/me" do
    test "returns current user for authenticated request", %{conn: conn} do
      user = insert(:user, email: "test@example.com", name: "Test User")
      
      conn = 
        conn
        |> put_req_header("authorization", "Bearer #{create_auth_token(user)}")
        |> get("/api/auth/me")

      assert %{
        "data" => %{
          "user" => user_data
        }
      } = json_response(conn, 200)

      assert user_data["id"] == user.id
      assert user_data["email"] == "test@example.com"
      assert user_data["name"] == "Test User"
    end

    test "returns unauthorized for unauthenticated request", %{conn: conn} do
      conn = get(conn, "/api/auth/me")

      assert %{
        "error" => %{
          "message" => "Unauthorized"
        }
      } = json_response(conn, 401)
    end

    test "returns unauthorized for invalid token", %{conn: conn} do
      conn = 
        conn
        |> put_req_header("authorization", "Bearer invalid_token")
        |> get("/api/auth/me")

      assert %{
        "error" => %{
          "message" => "Unauthorized"
        }
      } = json_response(conn, 401)
    end
  end

  describe "DELETE /api/auth/logout" do
    test "logs out user successfully", %{conn: conn} do
      user = insert(:user)
      
      conn = 
        conn
        |> put_req_header("authorization", "Bearer #{create_auth_token(user)}")
        |> delete("/api/auth/logout")

      assert %{
        "data" => %{
          "message" => "Logged out successfully"
        }
      } = json_response(conn, 200)
    end

    test "returns unauthorized for unauthenticated request", %{conn: conn} do
      conn = delete(conn, "/api/auth/logout")

      assert %{
        "error" => %{
          "message" => "Unauthorized"
        }
      } = json_response(conn, 401)
    end
  end
end