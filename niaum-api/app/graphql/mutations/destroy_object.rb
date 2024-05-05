# frozen_string_literal: true

module Mutations
  VALID_DESTROY_CLASSES = [
    ModelAttachment,
    JobRecord
  ].freeze

  class DestroyObject < ModelMutation
    def ready?(**kwargs)
      object = kwargs[:object]

      return [false, { errors: ["Invalid object class: #{object.class}"] }] unless VALID_DESTROY_CLASSES.include? object.class

      return [false, { errors: ["You don't have permission to destroy #{object}"] }] unless user_context.can_destroy?(object)

      super
    end

    model_argument :object, nil, required: true

    def run(**kwargs)
      object = kwargs[:object]

      destroy_object = object.destroy

      if !!destroy_object && destroy_object.destroyed?
        {
          errors: []
        }
      else
        {
          errors: object.errors.full_messages
        }
      end
    end
  end
end
