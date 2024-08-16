# frozen_string_literal: true

module Types
  module Store
    class RichTextJsonType < Types::Store::BaseType
      field :content, String, null: true
      field :content_html, String, null: true

      enum_field :format, values: %w[lexical plain]
    end
  end
end
