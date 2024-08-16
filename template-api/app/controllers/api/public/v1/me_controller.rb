# frozen_string_literal: true

module Api
  module Public
    module V1
      class MeController < ApiController
        def index
          render json: Blueprints::UserBlueprint.render(current_user)
        end
      end
    end
  end
end
