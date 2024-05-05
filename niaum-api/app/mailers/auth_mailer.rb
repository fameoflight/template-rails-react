# frozen_string_literal: true

# Note(hemantv): this is default mailer used by devise

class AuthMailer < Devise::Mailer
  layout 'mailer'
  include DomainConcern

  def password_change(user, _opts = {})
    @user = user

    mail(to: user_to(user), subject: 'Your password has been changed')
  end

  def confirmation_instructions(user, token, _opts = {})
    @user = user
    @confirmation_link = full_url("/auth/confirm/#{token}")

    mail(to: user_to(user), subject: 'Confirm your email')
  end

  def reset_password_instructions(user, token, _opts = {})
    @user = user

    @reset_password_link = full_url("/auth/reset/#{token}")

    mail(to: user_to(user), subject: 'Reset your password')
  end
end
