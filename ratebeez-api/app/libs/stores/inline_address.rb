# frozen_string_literal: true

module Stores
  class InlineAddress < Stores::Model
    attribute :street1, :string
    attribute :street2, :string
    attribute :city, :string
    attribute :state, :string
    attribute :zip, :string
    attribute :country, :string

    # validates :street1, :city, :state, :country, presence: true

    validates :state, length: { is: 2 }, allow_blank: true
    validates :country, length: { is: 2 }, allow_blank: true
  end
end
