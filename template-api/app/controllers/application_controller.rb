# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActiveStorage::SetCurrent

  include DeviseTokenAuth::Concerns::SetUserByToken
  include ErrorHandler
  include CorsHelper

  before_bugsnag_notify :add_diagnostics_to_bugsnag

  before_action :configure_devise_parameters, if: :devise_controller?

  before_action :set_paper_trail_whodunnit

  def user_context
    @user_context ||= UserContext.new(current_user)
  end

  def info_for_paper_trail
    {
      metadata: {
        ip: request.remote_ip,
        user_agent: request.user_agent
      },
      user_id: user_context.real_user&.id,
      current_user_id: user_context.current_user&.id
    }
  end

  protected

  def respond_with_format(result, status: :ok)
    respond_to do |format|
      format.msgpack do
        render plain: result.to_msgpack, content_type: 'application/x-msgpack', status: status
      end
      format.json do
        render json: result, status: status
      end
    end
  end

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name inviteCode])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end

  def add_diagnostics_to_bugsnag(report)
    report.user = user_context.real_user

    report.add_metadata(:request, url: request.url,
                                  user_agent: request.user_agent)
  end

  def verify_signed_in
    raise_error(status: 403, message: 'Not Signed In') if current_user.nil?
  end
end
