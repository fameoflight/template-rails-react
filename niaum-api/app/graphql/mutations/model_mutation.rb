# frozen_string_literal: true

module Mutations
  class ModelMutation < Mutations::BaseMutation
    extend Helpers::EnumHelpers
    extend Helpers::ModelArgument
    include Helpers::PostgresModelHelpers

    class << self
      def setup_mutation(graphql_type, **kwargs)
        self.field_name = kwargs[:field_name]

        self.model_name = graphql_type.model_name

        field field_name, graphql_type

        arguments = kwargs[:arguments] || []

        expose_model_column_arguments arguments

        required = kwargs[:required] || false

        valid_required_values = [true, false, :nil]

        assert valid_required_values.include?(required), "required must be one of #{valid_required_values.join(', ')}"

        # Note(hemantv): earlier we were using graphql-ruby default loads
        # it fails in case of if we want to to do mutations from miniuser id on user object
        # for this removed the loads and handling conversion of object_id to object
        model_argument :object, graphql_type, required: required unless required == :nil
      end

      def model_enum_argument(name, **)
        enum_argument(name, values: model.send(name).values, **)
      end
    end

    # def ready?(**kwargs)
    #   object = kwargs[:object]

    #   if object
    #     return default_error unless user_context.can_edit?(object)
    #   end

    #   super
    # end

    def default_error(verb = 'update')
      message = "You don't have permission to #{verb} #{field_name.to_s.titleize}"

      [false, { errors: [message] }]
    end
  end
end
