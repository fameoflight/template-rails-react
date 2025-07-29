defmodule TemplatePhoenixApiWeb.Schema.Types.AuthTest do
  use TemplatePhoenixApi.DataCase

  describe "register mutation" do
    test "creates user with valid input" do
      query = """
      mutation RegisterUser($input: RegisterInput!) {
        register(input: $input) {
          user {
            id
            email
            name
            confirmed
          }
          token
        }
      }
      """

      variables = %{
        input: %{
          email: "test@example.com",
          name: "Test User",
          password: "password123"
        }
      }

      assert {:ok, result} = graphql_execute(query, variables)
      
      user_data = result["register"]["user"]
      token = result["register"]["token"]

      assert user_data["email"] == "test@example.com"
      assert user_data["name"] == "Test User"
      assert user_data["confirmed"] == false
      assert is_binary(token)
    end

    test "returns error for invalid input" do
      query = """
      mutation RegisterUser($input: RegisterInput!) {
        register(input: $input) {
          user {
            id
          }
          token
        }
      }
      """

      variables = %{
        input: %{
          email: "invalid-email",
          name: "",
          password: "short"
        }
      }

      assert {:error, errors} = graphql_execute(query, variables)
      assert length(errors) > 0
    end
  end

  describe "login mutation" do
    test "authenticates user with valid credentials" do
      user = insert(:user, email: "test@example.com", name: "Test User")

      query = """
      mutation LoginUser($input: LoginInput!) {
        login(input: $input) {
          user {
            id
            email
            name
          }
          token
        }
      }
      """

      variables = %{
        input: %{
          email: "test@example.com",
          password: "password123"
        }
      }

      assert {:ok, result} = graphql_execute(query, variables)
      
      user_data = result["login"]["user"]
      token = result["login"]["token"]

      assert user_data["id"] == user.id
      assert user_data["email"] == "test@example.com"
      assert user_data["name"] == "Test User"
      assert is_binary(token)
    end

    test "returns error for invalid credentials" do
      insert(:user, email: "test@example.com")

      query = """
      mutation LoginUser($input: LoginInput!) {
        login(input: $input) {
          user {
            id
          }
          token
        }
      }
      """

      variables = %{
        input: %{
          email: "test@example.com",
          password: "wrongpassword"
        }
      }

      assert {:error, errors} = graphql_execute(query, variables)
      assert length(errors) > 0
      assert Enum.any?(errors, fn error -> 
        message = error["message"] || error[:message] || ""
        String.contains?(message, "Invalid email or password") 
      end)
    end
  end

  describe "env query" do
    test "returns current environment" do
      query = """
      query {
        env
      }
      """

      assert {:ok, result} = graphql_execute(query)
      assert result["env"] in ["dev", "test", "prod"]
    end
  end
end