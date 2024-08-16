# frozen_string_literal: true

module Types
  module ModelInterface
    include Types::BaseInterface
    implements GraphQL::Types::Relay::Node

    field :model_id, Int, null: false, hash_key: :id

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
