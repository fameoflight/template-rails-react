# frozen_string_literal: true

module Stores
  class RichText < Stores::Model
    enumerize :format, in: %i[plain lexical], default: :lexical

    enumerize :format_version, in: ['0.30'], default: '0.30'

    attribute :content, :string
    attribute :content_html, :string

    delegate :blank?, to: :content

    delegate :present?, to: :content
  end
end
