# frozen_string_literal: true

module Stores
  class RichText < Stores::Model
    enumerize :format, in: %i[plain lexical], default: :lexical

    attribute :content, :string
    attribute :content_html, :string

    validates :content, presence: true

    delegate :blank?, to: :content

    delegate :present?, to: :content

    # validate content is a valid JSON string

    validate :content_is_json

    def content_is_json
      JSON.parse(content)
    rescue JSON::ParserError
      errors.add(:content, 'is not a valid JSON string')
    end
  end
end
