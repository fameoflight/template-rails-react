# frozen_string_literal: true

module Api
  module Exceptions
    class Base < StandardError
      attr_reader :status, :messages

      def initialize(opts)
        @status = opts[:status] || 500

        @messages = opts[:messages] || []

        @messages << opts[:message] if opts[:message]

        @messages << 'Something went wrong' if @messages.empty?

        super
      end

      def as_json(_opts)
        {
          status:,
          errors: messages
        }
      end
    end
  end
end
