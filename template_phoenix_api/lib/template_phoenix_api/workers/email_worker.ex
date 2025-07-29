defmodule TemplatePhoenixApi.Workers.EmailWorker do
  use Oban.Worker, queue: :mailer

  alias TemplatePhoenixApi.Mailers.AuthMailer
  alias TemplatePhoenixApi.Accounts

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"type" => "confirmation_instructions", "user_id" => user_id, "token" => token}}) do
    user = Accounts.get_user!(user_id)
    
    user
    |> AuthMailer.confirmation_instructions(token)
    |> AuthMailer.deliver()
    
    :ok
  end

  def perform(%Oban.Job{args: %{"type" => "reset_password_instructions", "user_id" => user_id, "token" => token}}) do
    user = Accounts.get_user!(user_id)
    
    user
    |> AuthMailer.reset_password_instructions(token)
    |> AuthMailer.deliver()
    
    :ok
  end

  def perform(%Oban.Job{args: %{"type" => "password_change", "user_id" => user_id}}) do
    user = Accounts.get_user!(user_id)
    
    user
    |> AuthMailer.password_change()
    |> AuthMailer.deliver()
    
    :ok
  end

  # Helper functions to enqueue jobs
  def send_confirmation_instructions(user, token) do
    %{
      "type" => "confirmation_instructions",
      "user_id" => user.id,
      "token" => token
    }
    |> __MODULE__.new()
    |> Oban.insert()
  end

  def send_reset_password_instructions(user, token) do
    %{
      "type" => "reset_password_instructions", 
      "user_id" => user.id,
      "token" => token
    }
    |> __MODULE__.new()
    |> Oban.insert()
  end

  def send_password_change(user) do
    %{
      "type" => "password_change",
      "user_id" => user.id
    }
    |> __MODULE__.new()
    |> Oban.insert()
  end
end