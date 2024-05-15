# frozen_string_literal: true

module Types
  module Store
    class InlineAddressType < Types::Store::BaseType # rubocop:disable GraphQL/GraphqlName
      graphql_name 'InlineAddress'

      field :city, String, null: false
      field :country, String, null: false
      field :state, String, null: false
      field :street1, String, null: false
      field :street2, String, null: true
      field :zip, String, null: true
    end
  end
end
