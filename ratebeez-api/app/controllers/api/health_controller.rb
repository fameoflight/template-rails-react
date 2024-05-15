# frozen_string_literal: true

module Api
  class HealthController < ApplicationController
    def index
      services = {
        migration: migration_status
      }

      status = services.values.all?('ok') ? :ok : :service_unavailable

      render json: services, status:
    end

    private

    def migration_status
      ActiveRecord::Migration.check_pending! ? 'pending' : 'ok'
    end
  end
end
