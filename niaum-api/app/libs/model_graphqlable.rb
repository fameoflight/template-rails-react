# frozen_string_literal: true

module ModelGraphqlable
  extend ActiveSupport::Concern
  included do
    attr_accessor :graphql_class

    def self.graphql_find_by(*args)
      # Note(hemantv): this is for model where uuid is the primary key
      if args.length == 1 && args.first.is_a?(Hash) && args.first[:id]
        find(args.first[:id])
      else
        find_by(*args)
      end
    end
  end
end
