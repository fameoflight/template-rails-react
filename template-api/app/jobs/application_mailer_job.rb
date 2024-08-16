# frozen_string_literal: true

class ApplicationMailerJob < ApplicationJob
  def perform(mailer, mail_method, delivery_method, *args)
    # Bugsnag.leave_breadcrumb 'ActionMail delivered', method: mail_method, mailer: mailer.to_s

    mailer.constantize.public_send(mail_method, *args).send(delivery_method)
  end

  private

  def mailer_class
    (Array(@serialized_arguments).first || Array(arguments).first)&.constantize
  end
end
