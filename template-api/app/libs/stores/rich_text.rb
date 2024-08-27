# frozen_string_literal: true

module Stores
  class RichText < Stores::Model
    FORMATS = %w[plain markdown lexical].freeze

    enumerize :format, in: FORMATS, default: nil

    attribute :content, :string
    attribute :content_html, :string
    attribute :content_markdown, :string

    delegate :blank?, to: :content

    delegate :present?, to: :content

    validates :content, presence: true
    validates :format, presence: true, inclusion: { in: FORMATS }, allow_nil: false

    validate :content_is_json

    def content_is_json
      begin
        JSON.parse(content || '{}')
      rescue JSON::ParserError => e
        errors.add(:content, e.message)
      end

      if format == 'markdown'
        errors.add(:content_markdown, 'is required') if content_markdown.blank?
      end
    end
  end
end
