defmodule TemplatePhoenixApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :name, :string
      add :encrypted_password, :string
      add :confirmation_token, :string
      add :confirmed_at, :utc_datetime
      add :confirmation_sent_at, :utc_datetime
      add :reset_password_token, :string
      add :reset_password_sent_at, :utc_datetime
      add :current_sign_in_at, :utc_datetime
      add :last_sign_in_at, :utc_datetime
      add :current_sign_in_ip, :string
      add :last_sign_in_ip, :string
      add :sign_in_count, :integer
      add :failed_attempts, :integer
      add :locked_at, :utc_datetime
      add :unlock_token, :string
      add :nickname, :string
      add :otp_secret, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
