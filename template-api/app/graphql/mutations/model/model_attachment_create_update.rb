# frozen_string_literal: true

module Mutations
  module Model
    class ModelAttachmentCreateUpdate < Mutations::CreateUpdateMutation
      def ready?(**kwargs)
        return true if user_context.super?

        super
      end

      setup_mutation Types::Model::ModelAttachmentType, arguments: %i[name], required: false

      model_argument :owner, nil, required: true

      attachment_argument :attachment, required: false

      def run(**kwargs)
        original_owner = kwargs[:owner]

        kwargs[:owner] = original_owner.try(:model_attachment_owner) || original_owner

        company = kwargs[:owner]&.company || user_context.company

        kwargs[:company] = company

        super.tap do |result|
          return_object = result[field_name]

          original_owner.after_attachment_create(return_object) if original_owner != kwargs[:owner]
        end
      end
    end
  end
end
