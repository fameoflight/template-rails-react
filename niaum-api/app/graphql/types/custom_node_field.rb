# frozen_string_literal: true

module Types
  module CustomNodeField
    extend ActiveSupport::Concern

    included do
      field :custom_node, GraphQL::Types::Relay::Node, null: true, extras: [:lookahead] do
        argument :name, GraphQL::Types::String, required: true
        argument :id, GraphQL::Types::ID, required: true
      end
    end

    def custom_node(name:, id:, lookahead:)
      schema = context.schema

      node_object = schema.object_from_id(id, nil)

      fragment_names = inline_fragment_names(lookahead)

      assert fragment_names.include?(name), "Fragment #{name} not found in #{fragment_names}"

      graphql_klass = schema.get_type(name)

      assert node_object.is_a?(graphql_klass.model), "Object #{node_object.class} is not a #{graphql_klass.model}"

      node_id_with_name = schema.id_from_object(node_object, graphql_klass, nil)

      schema.object_from_id(node_id_with_name, nil)
    end

    private

    def inline_fragment_names(lookahead)
      lookahead.ast_nodes.map do |ast_node|
        inline_fragments = ast_node.children.select { |child| child.is_a?(GraphQL::Language::Nodes::InlineFragment) }

        inline_fragments.map { |inline_fragment| inline_fragment.type.name }
      end.flatten.uniq
    end
  end
end
