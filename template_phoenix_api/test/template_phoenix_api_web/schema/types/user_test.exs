defmodule TemplatePhoenixApiWeb.Schema.Types.UserTest do
  use TemplatePhoenixApi.DataCase

  describe "current_user query" do
    test "returns current user when authenticated" do
      user = insert(:user, email: "test@example.com", name: "Test User")

      query = """
      query {
        currentUser {
          id
          modelId
          email
          name
          confirmed
          firstName
          otpEnabled
          createdAt
          updatedAt
        }
      }
      """

      assert {:ok, result} = graphql_execute_with_user(query, %{}, user)
      
      user_data = result["currentUser"]
      assert user_data["id"] == user.id
      assert user_data["email"] == "test@example.com"
      assert user_data["name"] == "Test User"
      assert user_data["confirmed"] == false
      assert user_data["otpEnabled"] == false
    end

    test "returns error when not authenticated" do
      query = """
      query {
        currentUser {
          id
          email
        }
      }
      """

      assert {:error, errors} = graphql_execute(query)
      assert length(errors) > 0
      assert Enum.any?(errors, fn error -> 
        message = error["message"] || error[:message] || ""
        String.contains?(message, "Not authenticated") 
      end)
    end
  end

  describe "users query" do
    test "returns list of users when authenticated" do
      user = insert(:user)
      user2 = insert(:user, email: "user2@example.com")

      query = """
      query {
        users {
          id
          email
          name
        }
      }
      """

      assert {:ok, result} = graphql_execute_with_user(query, %{}, user)
      
      users_data = result["users"]
      assert length(users_data) == 2
      
      emails = Enum.map(users_data, & &1["email"])
      assert user.email in emails
      assert user2.email in emails
    end

    test "returns error when not authenticated" do
      insert(:user)

      query = """
      query {
        users {
          id
          email
        }
      }
      """

      assert {:error, errors} = graphql_execute(query)
      assert length(errors) > 0
      assert Enum.any?(errors, fn error -> 
        message = error["message"] || error[:message] || ""
        String.contains?(message, "Not authenticated") 
      end)
    end
  end

  describe "user fields" do
    test "confirmed field returns correct value" do
      confirmed_user = insert(:confirmed_user)
      unconfirmed_user = insert(:user)

      query = """
      query {
        users {
          id
          confirmed
        }
      }
      """

      assert {:ok, result} = graphql_execute_with_user(query, %{}, confirmed_user)
      
      users_data = result["users"]
      confirmed_data = Enum.find(users_data, & &1["id"] == confirmed_user.id)
      unconfirmed_data = Enum.find(users_data, & &1["id"] == unconfirmed_user.id)
      
      assert confirmed_data["confirmed"] == true
      assert unconfirmed_data["confirmed"] == false
    end

    test "otpEnabled field returns correct value" do
      user_with_otp = insert(:user_with_otp)
      user_without_otp = insert(:user)

      query = """
      query {
        users {
          id
          otpEnabled
        }
      }
      """

      assert {:ok, result} = graphql_execute_with_user(query, %{}, user_with_otp)
      
      users_data = result["users"]
      otp_user_data = Enum.find(users_data, & &1["id"] == user_with_otp.id)
      regular_user_data = Enum.find(users_data, & &1["id"] == user_without_otp.id)
      
      assert otp_user_data["otpEnabled"] == true
      assert regular_user_data["otpEnabled"] == false
    end

    test "firstName field returns correct value" do
      user = insert(:user, name: "John Doe Smith")

      query = """
      query {
        currentUser {
          firstName
        }
      }
      """

      assert {:ok, result} = graphql_execute_with_user(query, %{}, user)
      
      user_data = result["currentUser"]
      assert user_data["firstName"] == "John"
    end
  end
end