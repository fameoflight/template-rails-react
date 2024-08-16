# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'

module PostmarkTemplate
  extend ActiveSupport::Concern
  READ_ONLY_HEADERS = %w[body content_type subject].freeze
  BODY_STUB = 'Temporary Postmark Template Body'
  SUBJECT_STUB = 'Temporary Postmark Template Subject'

  included do
    mailer_name = mailer.name.split('::')[-1]

    template_prefix = mailer_name.chomp('Mailer').underscore

    mailer.default(
      body: BODY_STUB,
      content_type: 'text/plain',
      subject: SUBJECT_STUB,
      postmark_template_alias: proc {
        "#{template_prefix}_#{action_name}"
      }
    )

    mailer.extend(ClassMethods)
  end

  def template_model(*args)
    message.template_model(*args)
  end

  delegate :template_model=, to: :message

  def mail(headers = {})
    super(self.class.safe_headers(headers))
  ensure
    message.body = standard_template_body
    message.subject = standard_template_subject
  end

  private

  module ClassMethods
    def default(headers = {})
      super(safe_headers(headers))
    end

    def safe_headers(headers = {})
      headers = ActiveSupport::HashWithIndifferentAccess.new(headers)

      # violation = READ_ONLY_HEADERS.find { |h| headers.key?(h) }
      # raise ArgumentError, "Overriding '#{violation}' header in a templated mailer is not allowed." if violation

      headers.except(READ_ONLY_HEADERS)
    end
  end

  def standard_template_body
    "
    This message is using a Postmark template.\n\n
    Alias: #{message.template_alias.inspect}\n
    Model:\n#{JSON.pretty_generate(message.template_model || {})}\n\n
    Use the #prerender method on this object to contact the Postmark API
    to pre-render the template.\n\n
    Cheers,\n
    Your friends at Postmark
    "
  end

  def standard_template_subject
    "Postmark Template: #{message.template_alias.inspect}"
  end
end
