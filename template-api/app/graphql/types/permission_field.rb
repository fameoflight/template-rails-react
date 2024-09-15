# frozen_string_literal: true

module Types
  module PermissionField
    extend ActiveSupport::Concern

    class_methods do
      def permission_field(name, graphql_type, **kwargs)
        roles = kwargs.delete(:roles) || %i[user]
        null = kwargs.delete(:null) || true

        method_name = :"permission_#{name}"

        field name, graphql_type, null:, **kwargs, resolver_method: method_name

        define_method(method_name) do
          object_permission?(object, roles) ? object_value(object, name) : nil
        end
      end
    end

    def object_value(object, field)
      try(field) || object.try(field)
    end

    def object_permission?(object, roles)
      return user_context.super? if roles.include?(:super)

      user_context.object_user(object) == user_context.current_user
    end
  end
end
