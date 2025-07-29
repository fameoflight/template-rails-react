defmodule TemplatePhoenixApi.AccountsTest do
  use TemplatePhoenixApi.DataCase

  alias TemplatePhoenixApi.Accounts

  describe "authenticate_user/2" do
    test "returns {:ok, user} for valid credentials" do
      user = insert(:user, email: "test@example.com")
      
      assert {:ok, returned_user} = Accounts.authenticate_user("test@example.com", "password123")
      assert returned_user.id == user.id
    end

    test "returns {:error, :invalid_credentials} for invalid email" do
      assert {:error, :invalid_credentials} = Accounts.authenticate_user("nonexistent@example.com", "password123")
    end

    test "returns {:error, :invalid_credentials} for invalid password" do
      insert(:user, email: "test@example.com")
      
      assert {:error, :invalid_credentials} = Accounts.authenticate_user("test@example.com", "wrongpassword")
    end

    test "updates sign in information on successful authentication" do
      user = insert(:user, email: "test@example.com", sign_in_count: 0)
      
      assert {:ok, _} = Accounts.authenticate_user("test@example.com", "password123")
      
      updated_user = Accounts.get_user!(user.id)
      assert updated_user.sign_in_count == 1
      assert updated_user.current_sign_in_at != nil
    end
  end

  describe "generate_confirmation_token/1" do
    test "generates and sets confirmation token" do
      user = insert(:user)
      
      assert {:ok, updated_user} = Accounts.generate_confirmation_token(user)
      assert updated_user.confirmation_token != nil
      assert updated_user.confirmation_sent_at != nil
    end
  end

  describe "confirm_user/1" do
    test "confirms user with valid token" do
      user = insert(:user)
      {:ok, user_with_token} = Accounts.generate_confirmation_token(user)
      
      assert {:ok, confirmed_user} = Accounts.confirm_user(user_with_token.confirmation_token)
      assert confirmed_user.confirmed_at != nil
      assert confirmed_user.confirmation_token == nil
    end

    test "returns error for invalid token" do
      assert {:error, :invalid_token} = Accounts.confirm_user("invalid_token")
    end
  end

  describe "generate_reset_password_token/1" do
    test "generates reset password token for existing user" do
      _user = insert(:user, email: "test@example.com")
      
      assert {:ok, updated_user, token} = Accounts.generate_reset_password_token("test@example.com")
      assert updated_user.reset_password_token == token
      assert updated_user.reset_password_sent_at != nil
    end

    test "returns error for non-existent user" do
      assert {:error, :user_not_found} = Accounts.generate_reset_password_token("nonexistent@example.com")
    end
  end

  describe "reset_password/2" do
    test "resets password with valid token" do
      _user = insert(:user, email: "test@example.com")
      {:ok, _, token} = Accounts.generate_reset_password_token("test@example.com")
      
      assert {:ok, updated_user} = Accounts.reset_password(token, "newpassword123")
      assert TemplatePhoenixApi.Accounts.User.verify_password(updated_user, "newpassword123")
      assert updated_user.reset_password_token == nil
      assert updated_user.reset_password_sent_at == nil
    end

    test "returns error for invalid token" do
      assert {:error, :invalid_token} = Accounts.reset_password("invalid_token", "newpassword123")
    end

    test "returns error for expired token" do
      _user = insert(:user, email: "test@example.com")
      {:ok, user_with_token, token} = Accounts.generate_reset_password_token("test@example.com")
      
      # Manually set the token as expired (more than 24 hours ago)
      expired_time = DateTime.add(DateTime.utc_now(), -25 * 60 * 60, :second) |> DateTime.truncate(:second)
      user_with_token
      |> Ecto.Changeset.change(%{reset_password_sent_at: expired_time})
      |> Repo.update()
      
      assert {:error, :token_expired} = Accounts.reset_password(token, "newpassword123")
    end
  end
end