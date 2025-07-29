# Database Seeding Guide

This Phoenix application includes a comprehensive seeding system similar to Rails' `db:seed` functionality.

## Quick Start

```bash
# Seed development database
mix seed

# Reset and seed
mix seed --reset

# Use custom seed file
mix seed --file priv/repo/test_seeds.exs

# Force seed in production (be careful!)
mix seed --force
```

## Available Seed Files

### `seeds.exs` (Default)
Main seed file that loads environment-specific data:
- **Development**: Full sample data with users, blog posts, comments
- **Test**: Skips seeding (tests handle their own data)
- **Production**: Minimal admin user only

### `test_seeds.exs`
Minimal data for integration testing:
- Single test user for API testing

### `production_seeds.exs`
Production-safe minimal seeding:
- Creates admin user from environment variables
- Requires `ADMIN_PASSWORD` environment variable

## Seed Modules

### `TemplatePhoenixApi.Seeds.Users`
Creates users and related data:
- Admin user (`admin@test.com`)
- Regular user (`user@test.com`) 
- Unconfirmed user (`unconfirmed@test.com`)
- OTP-enabled user (`otp@test.com`)
- Super user records
- API access tokens

### `TemplatePhoenixApi.Seeds.Content`
Creates content data:
- Sample blog posts (published and draft)
- Comments on blog posts
- Sample attachment records
- Model attachments linking content

## Utility Functions

The `TemplatePhoenixApi.Seeds` module provides Rails-like helpers:

```elixir
# Find or create (like Rails find_or_create_by!)
user = Seeds.find_or_create_by!(User, %{email: "test@example.com"}, %{
  name: "Test User"
})

# Create or update (like Rails create_or_find_by!)
user = Seeds.create_or_update_by!(User, %{email: "test@example.com"}, %{
  name: "Updated Name"
})

# Bulk insert (like Rails insert_all)
Seeds.insert_all!(User, [
  %{email: "user1@example.com", name: "User 1"},
  %{email: "user2@example.com", name: "User 2"}
])

# Safe execution with error handling
Seeds.safe_execute("Creating sample data", fn ->
  # Some operation that might fail
end)
```

## Environment Variables

### Production Seeds
- `ADMIN_EMAIL`: Admin user email (default: `admin@yourcompany.com`)
- `ADMIN_PASSWORD`: Admin user password (required)
- `FORCE_SEED`: Set to `"true"` to allow seeding in production

### Development/Test
No environment variables required.

## Creating Custom Seeds

### 1. Create a seed file
```elixir
# priv/repo/my_custom_seeds.exs
alias TemplatePhoenixApi.{Repo, Accounts}

IO.puts("Creating custom data...")

# Your seeding logic here
{:ok, user} = Accounts.create_user(%{
  email: "custom@example.com",
  name: "Custom User",
  password: "password123"
})

IO.puts("✅ Custom seeding completed!")
```

### 2. Run your custom seeds
```bash
mix seed --file priv/repo/my_custom_seeds.exs
```

### 3. Create a reusable seed module
```elixir
# priv/repo/seeds/my_module.exs
defmodule TemplatePhoenixApi.Seeds.MyModule do
  alias TemplatePhoenixApi.{Repo, Accounts}
  
  def seed do
    IO.puts("🔧 Creating my custom data...")
    # Your logic here
    IO.puts("  ✓ Custom data created")
  end
end
```

Then include it in `seeds.exs`:
```elixir
Code.require_file("priv/repo/seeds/my_module.exs")
# ... in your environment case:
TemplatePhoenixApi.Seeds.MyModule.seed()
```

## Best Practices

1. **Idempotent Seeds**: Always check if data exists before creating
2. **Environment Safety**: Use environment checks for sensitive operations
3. **Error Handling**: Use `Seeds.safe_execute/2` for non-critical operations
4. **Logging**: Add clear logging for seed operations
5. **Clean Data**: Reset database if you need clean seeding

## Comparison to Rails

| Rails | Phoenix |
|-------|---------|
| `rails db:seed` | `mix seed` |
| `rails db:reset` | `mix seed --reset` |
| `db/seeds.rb` | `priv/repo/seeds.exs` |
| `find_or_create_by!` | `Seeds.find_or_create_by!` |
| `create_or_find_by!` | `Seeds.create_or_update_by!` |
| `insert_all` | `Seeds.insert_all!` |

The Phoenix seeding system provides similar functionality to Rails while taking advantage of Elixir's pattern matching and error handling capabilities.