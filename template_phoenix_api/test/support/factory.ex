defmodule TemplatePhoenixApi.Factory do
  use ExMachina.Ecto, repo: TemplatePhoenixApi.Repo

  def user_factory do
    %TemplatePhoenixApi.Accounts.User{
      name: Faker.Person.name(),
      email: sequence(:email, &"user#{&1}@example.com"),
      encrypted_password: Bcrypt.hash_pwd_salt("password123"),
      sign_in_count: 0,
      failed_attempts: 0
    }
  end

  def confirmed_user_factory do
    user_factory()
    |> Map.put(:confirmed_at, DateTime.utc_now() |> DateTime.truncate(:second))
  end

  def user_with_otp_factory do
    user_factory()
    |> Map.put(:otp_secret, "JBSWY3DPEHPK3PXP")
  end

  def message_factory do
    %TemplatePhoenixApi.Content.Message{
      content: Faker.Lorem.sentence(),
      room_id: sequence(:room_id, &"room-#{&1}"),
      user: build(:user)
    }
  end
end