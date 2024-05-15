# frozen_string_literal: true

module Types
  class BaseModelObject < Types::BaseObject
    include Helpers::PostgresModelHelpers

    implements Types::ModelInterface

    class << self
      def setup(model_name, **kwargs)
        self.model_name = model_name

        fields = kwargs[:fields] || []

        expose_model_column_fields fields
      end
    end

    field :id, 'ID', null: false

    def id
      RateBeezApiSchema.id_from_object(object, self.class, context)
    end
  end
end
