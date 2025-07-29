# Production seeds - only essential data
# Run with: mix seed --file priv/repo/production_seeds.exs --force

alias TemplatePhoenixApi.{Repo, Accounts, Admin}
alias TemplatePhoenixApi.Admin.SuperUser

IO.puts("🚀 Creating production data...")

# Only create admin user in production  
admin_email = System.get_env("ADMIN_EMAIL") || "admin@yourcompany.com"
admin_password = System.get_env("ADMIN_PASSWORD") || raise("ADMIN_PASSWORD environment variable is required for production seeds")

{:ok, admin_user} = Accounts.create_user(%{
  email: admin_email,
  name: "System Administrator",
  password: admin_password,
  confirmed_at: DateTime.utc_now()
})

# Create super user record
%SuperUser{
  id: admin_user.id,
  name: "System Administrator"
}
|> Repo.insert!(on_conflict: :nothing)

IO.puts("  ✓ Created admin user: #{admin_user.email}")
IO.puts("  ⚠️  Make sure to change the password after first login!")
IO.puts("✅ Production seeding completed!")