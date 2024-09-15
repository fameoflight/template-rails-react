# frozen_string_literal: true

module Mutations
  class CreateUpdateMutation < Mutations::ModelMutation
    field :current_user, Types::Model::UserType, null: true

    def run(**kwargs)
      # TODO(hemantv): remove nil values from mutation_types
      # This is really dangerous when we really want to unset the value
      # for now that's the problem for another time

      # just remove nil values from kwargs

      kwargs.each_key do |key|
        value = kwargs[key]

        kwargs.delete(key) if value.nil?

        kwargs[key] = nil if value == NULL_MARKER
      end

      object = kwargs.delete(:object)

      if object.nil?
        create(**kwargs)
      else
        update(object, **kwargs)
      end
    end

    def create(**kwargs)
      object = model.new(**kwargs)

      save_and_return(object)
    end

    def update(object, **kwargs)
      object.attributes = kwargs

      save_and_return(object)
    end

    def save_and_return(object)
      result = if object.save
                 {
                   success: true,
                   field_name => object,
                   errors: []
                 }
               else
                 {
                   success: false,
                   field_name => nil,
                   errors: object.errors.full_messages
                 }
               end

      result[:current_user] = user_context.current_user

      result
    end
  end
end
