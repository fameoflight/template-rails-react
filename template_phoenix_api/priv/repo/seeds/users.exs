defmodule TemplatePhoenixApi.Seeds.Users do
  @moduledoc """
  Seeds for users and related data
  """
  
  alias TemplatePhoenixApi.{Repo, Accounts}
  alias TemplatePhoenixApi.Accounts.{User, ApiAccessToken}
  alias TemplatePhoenixApi.Admin.SuperUser
  
  def seed do
    IO.puts("👤 Creating users...")
    
    # Create admin user
    admin_user = create_or_update_user(%{
      email: "admin@test.com",
      name: "Admin User",
      password: "testtest",
      confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
    })
    
    # Create regular test users
    regular_user = create_or_update_user(%{
      email: "user@test.com", 
      name: "Test User",
      password: "testtest",
      confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
    })
    
    unconfirmed_user = create_or_update_user(%{
      email: "unconfirmed@test.com",
      name: "Unconfirmed User", 
      password: "testtest"
    })
    
    # Create user with OTP enabled
    otp_user = create_or_update_user(%{
      email: "otp@test.com",
      name: "OTP User",
      password: "testtest",
      confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second),
      otp_secret: User.generate_otp_secret()
    })
    
    IO.puts("  ✓ Created admin user: #{admin_user.email}")
    IO.puts("  ✓ Created regular user: #{regular_user.email}")
    IO.puts("  ✓ Created unconfirmed user: #{unconfirmed_user.email}")
    IO.puts("  ✓ Created OTP user: #{otp_user.email}")
    
    # Create super user for admin
    create_or_update_super_user(admin_user)
    IO.puts("  ✓ Created super user for admin")
    
    # Create API access tokens
    create_api_tokens(admin_user)
    create_api_tokens(regular_user)
    IO.puts("  ✓ Created API access tokens")
    
    %{
      admin: admin_user,
      regular: regular_user, 
      unconfirmed: unconfirmed_user,
      otp: otp_user
    }
  end
  
  def seed_production do
    IO.puts("👤 Creating production admin user...")
    
    admin_user = create_or_update_user(%{
      email: System.get_env("ADMIN_EMAIL") || "admin@example.com",
      name: "Admin User",
      password: System.get_env("ADMIN_PASSWORD") || generate_secure_password(),
      confirmed_at: DateTime.utc_now() |> DateTime.truncate(:second)
    })
    
    create_or_update_super_user(admin_user)
    
    IO.puts("  ✓ Created admin user: #{admin_user.email}")
    IO.puts("  ⚠️  Make sure to change the default password!")
  end
  
  # Private helper functions
  
  defp create_or_update_user(attrs) do
    case Repo.get_by(User, email: attrs.email) do
      nil ->
        {:ok, user} = Accounts.create_user(attrs)
        user
        
      existing_user ->
        # For existing users, only update non-password fields to avoid issues
        update_attrs = Map.delete(attrs, :password)
        case Accounts.update_user(existing_user, update_attrs) do
          {:ok, user} -> user
          {:error, _} -> existing_user
        end
    end
  end
  
  defp create_or_update_super_user(user) do
    case Repo.get_by(SuperUser, id: user.id) do
      nil ->
        %SuperUser{
          id: user.id,
          name: "Super User for #{user.name}"
        }
        |> Repo.insert!(on_conflict: :nothing)
        
      existing ->
        existing
    end
  end
  
  defp create_api_tokens(user) do
    # Active token
    %ApiAccessToken{
      user_id: user.id,
      name: "Development Token",
      description: "Token for development testing",
      token: generate_token(),
      active: true,
      expires_at: DateTime.add(DateTime.utc_now(), 30 * 24 * 60 * 60, :second) |> DateTime.truncate(:second) |> DateTime.truncate(:second) # 30 days
    }
    |> Repo.insert!(on_conflict: :nothing)
    
    # Inactive token  
    %ApiAccessToken{
      user_id: user.id,
      name: "Inactive Token",
      description: "Inactive token for testing",
      token: generate_token(),
      active: false,
      expires_at: DateTime.add(DateTime.utc_now(), 30 * 24 * 60 * 60, :second) |> DateTime.truncate(:second)
    }
    |> Repo.insert!(on_conflict: :nothing)
  end
  
  defp generate_token do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
  end
  
  defp generate_secure_password do
    # Generate a secure 16-character password
    :crypto.strong_rand_bytes(12) |> Base.url_encode64(padding: false)
  end
end