# frozen_string_literal: true

module Api
  module Internal
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        before_action :validate_create, only: :create # rubocop:disable Rails/LexicallyScopedActionFilter

        attr_accessor :invite_code

        def validate_create
          @invite_code = params.delete(:inviteCode)
        end

        def render_create_success
          @resource.update(invite_code:)

          super
        end
      end
    end
  end
end
