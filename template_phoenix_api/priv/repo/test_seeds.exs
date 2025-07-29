# Test seeds - minimal data for test environment
# Run with: mix seed --file priv/repo/test_seeds.exs

alias TemplatePhoenixApi.{Repo, Accounts}

IO.puts("🧪 Creating minimal test data...")

# Create a single test user for integration tests
{:ok, test_user} = Accounts.create_user(%{
  email: "test@example.com",
  name: "Test User", 
  password: "password123",
  confirmed_at: DateTime.utc_now()
})

IO.puts("  ✓ Created test user: #{test_user.email}")
IO.puts("✅ Test seeding completed!")