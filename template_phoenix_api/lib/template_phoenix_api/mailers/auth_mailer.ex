defmodule TemplatePhoenixApi.Mailers.AuthMailer do
  use Swoosh.Mailer, otp_app: :template_phoenix_api
  import Swoosh.Email

  alias TemplatePhoenixApi.Accounts.User

  @from_email "Picasso Support <support@picasso.app>"
  @reply_to_email "Picasso Support <support@picasso.app>"

  def confirmation_instructions(%User{} = user, token) do
    confirmation_link = full_url("/auth/confirm/#{token}")
    
    new()
    |> to(user_to(user))
    |> from(@from_email)
    |> reply_to(@reply_to_email)
    |> subject("Confirm your email")
    |> html_body(confirmation_instructions_html(user, confirmation_link))
    |> text_body(confirmation_instructions_text(user, confirmation_link))
  end

  def reset_password_instructions(%User{} = user, token) do
    reset_password_link = full_url("/auth/reset/#{token}")
    
    new()
    |> to(user_to(user))
    |> from(@from_email)
    |> reply_to(@reply_to_email)
    |> subject("Reset your password")
    |> html_body(reset_password_instructions_html(user, reset_password_link))
    |> text_body(reset_password_instructions_text(user, reset_password_link))
  end

  def password_change(%User{} = user) do
    new()
    |> to(user_to(user))
    |> from(@from_email)
    |> reply_to(@reply_to_email)
    |> subject("Your password has been changed")
    |> html_body(password_change_html(user))
    |> text_body(password_change_text(user))
  end

  defp user_to(%User{} = user) do
    "#{user.name} <#{user.email}>"
  end

  defp domain do
    if Application.get_env(:template_phoenix_api, :environment) == :prod do
      "https://#{System.get_env("HOST", "picasso.app")}"
    else
      "http://localhost:3000"
    end
  end

  defp full_url(path) do
    "#{domain()}#{path}"
  end

  # HTML templates
  defp confirmation_instructions_html(user, link) do
    """
    <p>Hey #{user.first_name},</p>
    
    <p>
      You're almost there! Just click the button below to confirm your email address and get started.
    </p>
    
    <a href="#{link}" style="background-color: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Confirm my account</a>
    """
  end

  defp reset_password_instructions_html(user, link) do
    """
    <p>Hey #{user.first_name},</p>
    
    <p>
      You have requested to reset your password. Click the link below to reset it. If you did not request this, just ignore this e-mail and your password will stay the same.
    </p>
    
    <a href="#{link}" style="background-color: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Reset my password</a>
    """
  end

  defp password_change_html(user) do
    """
    <p>Hey #{user.first_name},</p>
    
    <p>
      Your password has been successfully changed. If you did not make this change, please contact support immediately.
    </p>
    """
  end

  # Text templates
  defp confirmation_instructions_text(user, link) do
    """
    Hey #{user.first_name},

    You're almost there! Just click the link below to confirm your email address and get started.

    #{link}
    """
  end

  defp reset_password_instructions_text(user, link) do
    """
    Hey #{user.first_name},

    You have requested to reset your password. Click the link below to reset it. If you did not request this, just ignore this e-mail and your password will stay the same.

    #{link}
    """
  end

  defp password_change_text(user) do
    """
    Hey #{user.first_name},

    Your password has been successfully changed. If you did not make this change, please contact support immediately.
    """
  end
end