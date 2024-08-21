# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Rails.env.development?
  User.create_or_update_by!(
    { email: 'admin@test.com' },
    update: {
      name: 'Admin User',
      password: 'testtest',
      confirmed_at: Time.zone.now
    }
  )

  puts 'Admin user created'
end
