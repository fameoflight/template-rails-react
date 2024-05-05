# frozen_string_literal: true

module Mutations
  VALID_DISCARD_MODELS = [
    ModelAttachment
  ].freeze

  class DiscardObject < ModelMutation
    def ready?(**kwargs)
      object = kwargs[:object]

      return [false, { errors: ["Invalid object class: #{object.class}"] }] unless VALID_DISCARD_MODELS.include? object.class

      return [false, { errors: ["You don't have permission to destroy #{object}"] }] unless user_context.can_discard?(object)

      super
    end

    model_argument :object, nil, required: true

    def run(**kwargs)
      object = kwargs[:object]

      if object.discard
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
