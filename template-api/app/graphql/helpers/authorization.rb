# frozen_string_literal: true

module Helpers
  module Authorization
    extend ActiveSupport::Concern

    # @return [User, nil]
    def current_user
      @context[:user_context]&.current_user
    end

    # return [UserContext]
    def user_context
      @context[:user_context]
    end
  end
end
