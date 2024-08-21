# frozen_string_literal: true

module Stores
  class RichText < Stores::Model
    FORMATS = %w[plain markdown html lexical].freeze

    enumerize :format, in: FORMATS, default: nil

    attribute :content, :string
    attribute :content_html, :string

    delegate :blank?, to: :content

    delegate :present?, to: :content

    validates :content, presence: true
    validates :format, presence: true, inclusion: { in: FORMATS }, allow_nil: false

    validate :content_is_json

    def content_is_json
      # check if content is a valid if format is lexical

      if format == 'lexical'
        begin
          JSON.parse(content)
        rescue JSON::ParserError => e
          errors.add(:content, e.message)
        end
      end
    end
  end
end
