# frozen_string_literal: true

module Stores
  class RichText < Stores::Model
    enumerize :format, in: %i[plain lexical], default: :lexical

    attribute :content, :string
    attribute :content_html, :string

    validates :content, presence: true

    delegate :blank?, to: :content

    delegate :present?, to: :content
  end
end
