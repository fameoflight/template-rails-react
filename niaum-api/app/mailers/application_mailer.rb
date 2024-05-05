# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  include DomainConcern

  attr_accessor :template_params

  def postmark_mail(to:, template_id:, **kwargs)
    message.template_model = template_params

    default_postmark_args = {
      to:,
      body: 'Temporary Postmark Template Body',
      content_type: 'text/plain',
      subject: 'Temporary Postmark Template Subject',
      postmark_template_alias: template_id
    }

    mail(**kwargs.merge(default_postmark_args))
  end

  def set_email_globals
    # set application name from i18n

    @application_name = I18n.t('application_name')
  end

  def mail(**kwargs)
    set_email_globals

    caller_method = caller_locations(1, 1)[0].label

    key = "#{self.class.name}##{caller_method}"

    Rails.logger.info("Sending email: #{key} with params: #{kwargs}")

    kwargs[:to] = convert_recievers(kwargs[:to])

    kwargs[:cc] = convert_recievers(kwargs[:cc]) if kwargs[:cc]

    kwargs[:bcc] = convert_recievers(kwargs[:bcc]) if kwargs[:bcc]

    super
  end

  def attach_invite_link_footer(company_employee)
    assert @invite_link.blank?, 'Invite link should not be set'

    # return unless %w[init created invited].include?(company_employee.status)

    @invite_link = full_url("/accept/employee/#{company_employee.invite_code}")
  end
end
