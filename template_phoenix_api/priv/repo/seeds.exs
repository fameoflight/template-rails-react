# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TemplatePhoenixApi.Repo.insert!(%TemplatePhoenixApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Load seed modules
Code.require_file("priv/repo/seeds/users.exs")
Code.require_file("priv/repo/seeds/content.exs")

# Get the current environment
env = Mix.env()

IO.puts("🌱 Seeding database for #{env} environment...")

# Run seeds based on environment
case env do
  :dev ->
    IO.puts("📝 Creating development data...")
    TemplatePhoenixApi.Seeds.Users.seed()
    TemplatePhoenixApi.Seeds.Content.seed()
    
  :development ->
    IO.puts("📝 Creating development data...")
    TemplatePhoenixApi.Seeds.Users.seed()
    TemplatePhoenixApi.Seeds.Content.seed()
    
  :test ->
    IO.puts("🧪 Test environment - skipping seeds")
    
  :prod ->
    IO.puts("🚀 Production environment - creating minimal required data only...")
    TemplatePhoenixApi.Seeds.Users.seed_production()
    
  _ ->
    IO.puts("⚠️  Unknown environment: #{env}")
end

IO.puts("✅ Seeding completed!")