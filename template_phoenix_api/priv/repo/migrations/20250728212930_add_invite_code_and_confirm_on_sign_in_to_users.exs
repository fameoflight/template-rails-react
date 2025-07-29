defmodule TemplatePhoenixApi.Repo.Migrations.AddInviteCodeAndConfirmOnSignInToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirm_on_sign_in, :boolean, default: false, null: false
      add :invite_code, :string, default: nil
    end
  end
end
