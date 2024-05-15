# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    # Evaluated from bottom to top
    # Meaning that your last defined handler will have the highest priority and
    # your first defined handler will have the lowest priority

    rescue_from Api::Exceptions::Base, with: :render_error_response

    rescue_from ActiveRecord::ActiveRecordError, with: :render_active_record_error
  end

  def render_error_response(error)
    render json: error, status: error.status
  end

  def render_active_record_error(error)
    base = Api::Exceptions::Base.new(status: 500, messages: [error.class.to_s, error.exception])

    render json: base, status: :internal_server_error
  end

  def raise_error(opts = {})
    raise Api::Exceptions::Base, opts
  end
end
