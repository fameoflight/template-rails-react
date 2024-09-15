# frozen_string_literal: true

module Types
  class CityType < Types::BaseObject
    field :admin1_name, String, null: true
    field :country, String, null: false
    field :lat, Float, null: false
    field :lng, Float, null: false
    field :name, String, null: false
  end
end
