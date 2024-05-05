# frozen_string_literal: true

module Api
  module Internal
    module Auth
      class SessionsController < DeviseTokenAuth::SessionsController
        def render_create_success
          if @resource.confirmed_at.nil? && @resource.confirm_on_sign_in
            @resource.update(confirmed_at: Time.current, confirm_on_sign_in: false)
          end

          super
        end
      end
    end
  end
end
