# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    include Helpers::Authorization
    include Helpers::ModelArgument

    field :errors, [String], null: false

    # by default transaction is enabled for all mutations let's create a way for it to disabled
    # this is required for active storage

    def resolve(**kwargs)
      resp = {}

      # Note(hemantv): this is to ensure that we are not running authorization on
      # rendering of mutation result.
      @context[:skip_authorization] = true

      transactions = @context[:transactions].nil? ? true : @context[:transactions]

      Rails.logger.warn "Transactions are disabled for #{self.class.name}" unless transactions

      begin
        if transactions
          ActiveRecord::Base.transaction do
            resp = run(**kwargs)

            raise ActiveRecord::Rollback unless resp[:errors].empty?
          end
        else
          resp = run(**kwargs)
        end
      rescue ActiveRecord::Rollback => e
        Bugsnag.notify(e)

        Rails.logger.error "#{self.class.name}# rollback: #{resp[:errors]} #{e.message}"
      end

      resp
    end

    def run(**kwargs)
      raise NotImplementedError
    end

    def without_versioning(&)
      PaperTrail.request(enabled: false, &)
    end
  end
end
