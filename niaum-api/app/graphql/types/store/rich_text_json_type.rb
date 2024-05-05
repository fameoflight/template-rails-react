# frozen_string_literal: true

module Types
  module Store
    class RichTextJsonType < Types::Store::BaseType # rubocop:disable GraphQL/GraphqlName
      graphql_name 'RichTextJson'

      field :content, String, null: true
      field :content_html, String, null: true

      field :format_version, String, null: false

      enum_field :format, values: %w[lexical plain]
    end
  end
end
