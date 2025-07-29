defmodule TemplatePhoenixApi.Accounts.UserTest do
  use TemplatePhoenixApi.DataCase

  alias TemplatePhoenixApi.Accounts.User

  describe "user creation" do
    test "creates a user with valid attributes" do
      user_attrs = %{
        name: "Test User",
        email: "test@example.com",
        password: "password123"
      }

      _user = build(:user)
      assert {:ok, %User{} = created_user} = TemplatePhoenixApi.Accounts.create_user(user_attrs)
      assert created_user.name == "Test User"
      assert created_user.email == "test@example.com"
      assert User.verify_password(created_user, "password123")
    end

    test "requires email and name" do
      user_attrs = %{password: "password123"}
      
      assert {:error, changeset} = TemplatePhoenixApi.Accounts.create_user(user_attrs)
      assert %{email: ["can't be blank"], name: ["can't be blank"]} = errors_on(changeset)
    end

    test "requires unique email" do
      _user1 = insert(:user, email: "test@example.com")
      user_attrs = %{
        name: "Test User 2",
        email: "test@example.com",
        password: "password123"
      }

      assert {:error, changeset} = TemplatePhoenixApi.Accounts.create_user(user_attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "requires valid email format" do
      user_attrs = %{
        name: "Test User",
        email: "invalid-email",
        password: "password123"
      }

      assert {:error, changeset} = TemplatePhoenixApi.Accounts.create_user(user_attrs)
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "requires password with minimum length" do
      user_attrs = %{
        name: "Test User",
        email: "test@example.com",
        password: "short"
      }

      assert {:error, changeset} = TemplatePhoenixApi.Accounts.create_user(user_attrs)
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
    end
  end

  describe "user functions" do
    test "first_name/1 returns first name from name" do
      user = build(:user, name: "John Doe")
      assert User.first_name(user) == "John"
    end

    test "first_name/1 returns nickname when name is nil" do
      user = build(:user, name: nil, nickname: "Johnny")
      assert User.first_name(user) == "Johnny"
    end

    test "first_name/1 returns 'User' when both name and nickname are nil" do
      user = build(:user, name: nil, nickname: nil)
      assert User.first_name(user) == "User"
    end

    test "confirmed?/1 returns true when confirmed_at is set" do
      user = build(:confirmed_user)
      assert User.confirmed?(user) == true
    end

    test "confirmed?/1 returns false when confirmed_at is nil" do
      user = build(:user)
      assert User.confirmed?(user) == false
    end

    test "otp_enabled?/1 returns true when otp_secret is set" do
      user = build(:user_with_otp)
      assert User.otp_enabled?(user) == true
    end

    test "otp_enabled?/1 returns false when otp_secret is nil" do
      user = build(:user)
      assert User.otp_enabled?(user) == false
    end

    test "locked?/1 returns true when locked_at is set" do
      user = build(:user, locked_at: DateTime.utc_now())
      assert User.locked?(user) == true
    end

    test "locked?/1 returns false when locked_at is nil" do
      user = build(:user)
      assert User.locked?(user) == false
    end
  end

  describe "password verification" do
    test "verify_password/2 returns true for correct password" do
      user = insert(:user)
      assert User.verify_password(user, "password123") == true
    end

    test "verify_password/2 returns false for incorrect password" do
      user = insert(:user)
      assert User.verify_password(user, "wrongpassword") == false
    end
  end

  describe "verify_password_with_otp/2" do
    test "returns true for user without OTP with plain password" do
      user = insert(:user) # No OTP secret
      assert User.verify_password_with_otp(user, "password123") == true
    end

    test "returns false for user without OTP with wrong plain password" do
      user = insert(:user) # No OTP secret
      assert User.verify_password_with_otp(user, "wrongpassword") == false
    end

    test "returns true for user without OTP with Base64 JSON payload (correct password)" do
      user = insert(:user) # No OTP secret
      
      # Simulate frontend encoding: Base64.encode64(JSON.stringify({password: "password123", otp: null}))
      json_payload = Jason.encode!(%{"password" => "password123", "otp" => nil})
      base64_payload = Base.encode64(json_payload)
      
      assert User.verify_password_with_otp(user, base64_payload) == true
    end

    test "returns true for user without OTP with Base64 JSON payload (no otp field)" do
      user = insert(:user) # No OTP secret
      
      # Simulate frontend encoding without OTP field
      json_payload = Jason.encode!(%{"password" => "password123"})
      base64_payload = Base.encode64(json_payload)
      
      assert User.verify_password_with_otp(user, base64_payload) == true
    end

    test "returns false for user without OTP with Base64 JSON payload (wrong password)" do
      user = insert(:user) # No OTP secret
      
      json_payload = Jason.encode!(%{"password" => "wrongpassword", "otp" => nil})
      base64_payload = Base.encode64(json_payload)
      
      assert User.verify_password_with_otp(user, base64_payload) == false
    end

    test "returns true for user with OTP enabled with correct password and OTP" do
      user = insert(:user_with_otp) # Has OTP secret
      
      # Generate a valid OTP using :pot library - it returns a string
      valid_otp = :pot.totp(user.otp_secret)
      
      # Create JSON payload manually to ensure OTP stays as string
      json_string = ~s({"password":"password123","otp":"#{valid_otp}"})
      base64_payload = Base.encode64(json_string)
      
      assert User.verify_password_with_otp(user, base64_payload) == true
    end

    test "returns false for user with OTP enabled with correct password but wrong OTP" do
      user = insert(:user_with_otp) # Has OTP secret
      
      json_payload = Jason.encode!(%{"password" => "password123", "otp" => "123456"})
      base64_payload = Base.encode64(json_payload)
      
      assert User.verify_password_with_otp(user, base64_payload) == false
    end

    test "returns false for user with OTP enabled with wrong password but correct OTP" do
      user = insert(:user_with_otp) # Has OTP secret
      
      # Generate a valid OTP using :pot library - it returns a string
      valid_otp = :pot.totp(user.otp_secret)
      
      json_string = ~s({"password":"wrongpassword","otp":"#{valid_otp}"})
      base64_payload = Base.encode64(json_string)
      
      assert User.verify_password_with_otp(user, base64_payload) == false
    end

    test "returns false for user with OTP enabled with Base64 JSON payload but no OTP" do
      user = insert(:user_with_otp) # Has OTP secret
      
      json_payload = Jason.encode!(%{"password" => "password123"})
      base64_payload = Base.encode64(json_payload)
      
      assert User.verify_password_with_otp(user, base64_payload) == false
    end

    test "returns false for user with OTP enabled with plain password" do
      user = insert(:user_with_otp) # Has OTP secret
      
      # Even with correct password, should fail because OTP is required
      assert User.verify_password_with_otp(user, "password123") == false
    end

    test "handles malformed Base64 payload gracefully for user without OTP" do
      user = insert(:user) # No OTP secret
      
      # Should fall back to treating as plain password
      assert User.verify_password_with_otp(user, "password123") == true
      assert User.verify_password_with_otp(user, "wrongpassword") == false
    end

    test "handles malformed Base64 payload gracefully for user with OTP" do
      user = insert(:user_with_otp) # Has OTP secret
      
      # Should reject malformed payload for OTP-enabled user
      assert User.verify_password_with_otp(user, "malformed_base64_payload") == false
    end
  end
end