# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  extend Enumerize

  include ModelGraphqlable

  def to_s
    "#{self.class.name} #{id}"
  end

  default_scope { default_scope_method }

  class << self
    def default_scope_method
      order("#{table_name}.id asc")
    end

    def create_or_update_by!(find_args, create: {}, update: {})
      record = find_by(find_args)

      if record
        record.update!(update) if update.present?
      else
        create_params = find_args.merge(create).merge(update)
        record = create!(create_params)
      end

      record
    end

    def polymorphic_belongs_to(name, **kwargs)
      in_values = kwargs.delete(:in)

      if in_values.present?
        default_in = kwargs.delete(:default_in)&.to_s

        in_values = in_values.map(&:to_s)

        enumerize "#{name}_type", in: in_values, default: default_in
      end

      belongs_to name, polymorphic: true, **kwargs
    end

    def store_attribute(name, store_type, **kwargs)
      array = kwargs.delete(:array) || false

      # Note(hemantv): store_type must support to_type and to_array_type methods
      attribute_type = array ? store_type.to_array_type : store_type.to_type

      attribute name, attribute_type, **kwargs

      store_model_validation_options = {}

      if array
        store_model_validation_options[:merge_array_errors] = true
      else
        store_model_validation_options[:merge_errors] = true
      end

      validates name, store_model: store_model_validation_options
    end
  end
end
