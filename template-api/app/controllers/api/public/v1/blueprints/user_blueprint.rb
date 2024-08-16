# frozen_string_literal: true

module Api
  module Public
    module V1
      module Blueprints
        class UserBlueprint < BaseBlueprint
          identifier :uuid

          fields :name, :email

          # association :company_employee, name: :employee, blueprint: CompanyEmployeeBlueprint
        end
      end
    end
  end
end
