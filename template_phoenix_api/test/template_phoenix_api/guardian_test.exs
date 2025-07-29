defmodule TemplatePhoenixApi.GuardianTest do
  use TemplatePhoenixApi.DataCase

  alias TemplatePhoenixApi.Guardian

  describe "authenticate/2" do
    test "returns {:ok, user, token} for valid credentials" do
      user = insert(:user, email: "test@example.com")
      
      assert {:ok, returned_user, token} = Guardian.authenticate("test@example.com", "password123")
      assert returned_user.id == user.id
      assert is_binary(token)
    end

    test "returns {:error, :unauthorized} for invalid credentials" do
      insert(:user, email: "test@example.com")
      
      assert {:error, :unauthorized} = Guardian.authenticate("test@example.com", "wrongpassword")
    end

    test "returns {:error, :unauthorized} for non-existent user" do
      assert {:error, :unauthorized} = Guardian.authenticate("nonexistent@example.com", "password123")
    end
  end

  describe "create_token/1" do
    test "creates a token for a user" do
      user = insert(:user)
      
      assert {:ok, returned_user, token} = Guardian.create_token(user)
      assert returned_user.id == user.id
      assert is_binary(token)
    end
  end

  describe "decode_token/1" do
    test "decodes a valid token" do
      user = insert(:user)
      {:ok, _, token} = Guardian.create_token(user)
      
      assert {:ok, decoded_user, _claims} = Guardian.decode_token(token)
      assert decoded_user.id == user.id
    end

    test "returns error for invalid token" do
      assert {:error, _reason} = Guardian.decode_token("invalid_token")
    end
  end

  describe "resource_from_claims/1" do
    test "returns user from valid claims" do
      user = insert(:user)
      claims = %{"sub" => user.id}
      
      assert {:ok, returned_user} = Guardian.resource_from_claims(claims)
      assert returned_user.id == user.id
    end

    test "returns error for non-existent user" do
      claims = %{"sub" => Ecto.UUID.generate()}
      
      assert {:error, :resource_not_found} = Guardian.resource_from_claims(claims)
    end

    test "returns error for invalid claims" do
      assert {:error, :reason_for_error} = Guardian.resource_from_claims(%{})
    end
  end

  describe "subject_for_token/2" do
    test "returns subject for user" do
      user = insert(:user)
      
      assert {:ok, subject} = Guardian.subject_for_token(user, %{})
      assert subject == user.id
    end

    test "returns error for invalid resource" do
      assert {:error, :reason_for_error} = Guardian.subject_for_token(%{invalid: :resource}, %{})
    end
  end
end