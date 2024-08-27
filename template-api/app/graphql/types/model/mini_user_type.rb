# frozen_string_literal: true

module Types
  module Model
    class MiniUserType < Types::BaseModelObject
      setup User, fields: %i[name nickname]

      field :personas, [Types::Model::PersonaType], null: false

      def personas
        Persona.where(user: object, status: :published)
      end
    end
  end
end
