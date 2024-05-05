# frozen_string_literal: true

class LowerCamelTransformer < Blueprinter::Transformer
  def transform(hash, _object, _options)
    # keys are symbols, have to convert to string to camelize then back to symbol
    hash.deep_transform_keys! { |key| key.to_s.camelize(:lower).to_sym }
  end
end

class BaseBlueprint < Blueprinter::Base
  identifier :id

  transform LowerCamelTransformer

  def self.describe_fields(name:, array: false)
    view_collection = send(:view_collection)

    keys = view_collection.views.map do |_view_key, view|
      view.fields.map do |_field_key, field|
        is_array = field.options[:array]

        if field.options[:blueprint]
          field.options[:blueprint].describe_fields(name: field.name, array: is_array)
        else
          { name: field.name, kind: is_array ? ['String'] : 'String' }
        end
      end
    end

    {
      kind: array ? ['Object'] : 'Object',
      name:,
      fields: keys.flatten
    }
  end
end
