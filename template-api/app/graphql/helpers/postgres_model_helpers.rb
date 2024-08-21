# frozen_string_literal: true

module Helpers
  module PostgresModelHelpers
    RICH_TEXT_PREFIX = %i[rich_text_ rt_].freeze

    extend ActiveSupport::Concern

    include Helpers::PostgresHelpers

    delegate :model, to: :class
    delegate :model_name, to: :class
    delegate :field_name, to: :class

    # rubocop:disable Metrics/BlockLength
    class_methods do
      attr_accessor :model_name, :field_name, :model

      def model_name=(value)
        @model_name = value.to_s
        @model = value.to_s.split('::').map(&:camelize).join('::').constantize

        @field_name = value.to_s.split('::').last.underscore.to_sym if field_name.nil?
      end

      def rich_text_column?(column_name)
        RICH_TEXT_PREFIX.any? do |prefix|
          column_name.to_s.start_with?(prefix.to_s)
        end
      end

      def expose_model_column_fields(columns, null: nil)
        enum_fields = _model_enum_fields_

        _internal_expose_model_column_(model, columns) do |column_name, column_type, column|
          column_null = null.nil? ? column.null : null

          if rich_text_column?(column_name)
            raise "#{RICH_TEXT_PREFIX} prefix is for rich text document" if column_type != GraphQL::Types::JSON

            field column_name, Types::Store::RichTextJsonType, null: column_null

            next
          end

          if enum_fields.include? column_name
            if column.type == :citext
              _internal_expose_enum_column_(column_name, column_type, column, null:)

              next
            else
              ConsolePrint.log "#{column_name} field is not citext", level: :warn, tag: model_name
            end
          end

          field column_name, column_type, null: column_null
        end
      end

      def expose_model_column_arguments(columns, required: nil)
        enum_fields = _model_enum_fields_

        _internal_expose_model_column_(model, columns) do |column_name, column_type, column|
          argument_required = required.nil? ? !column.null : required

          if rich_text_column?(column_name)
            raise "#{RICH_TEXT_PREFIX} prefix is for rich text document" if column_type != GraphQL::Types::JSON

            argument column_name, Types::Store::JsonInputType, required: argument_required

            next
          end

          if enum_fields.include? column_name
            if column.type == :citext
              _internal_expose_enum_argument_(column_name, column_type, column, required: argument_required)

              next
            else
              if column.type != :citext
                ConsolePrint.log "#{column_name} argument is not citext", level: :warn,
                                                                          tag: model_name
              end
            end
          end

          if argument_required
            argument column_name, column_type, required: argument_required
          else
            argument column_name, column_type, required: argument_required, default_value: nil
          end
        end
      end

      private

      def _model_enum_fields_
        model.try(:enumerized_attributes)&.attributes&.keys || []
      end

      def _internal_expose_model_column_(model, fields)
        fields = fields.map(&:to_s).uniq - ['id']

        column_hashes = model.columns_hash.except('id')

        column_hashes = column_hashes.select do |column|
          fields.include?(column.to_s)
        end

        if fields.length != column_hashes.length
          diff = fields - column_hashes.keys

          raise ArgumentError, "fields #{diff.join(', ')} not found in #{model}"
        end

        validations(column_hashes) unless Rails.env.production?

        column_hashes.each do |name, column|
          field_index = fields.find_index(name)

          yield(fields[field_index], convert_db_type(column), column)
        end
      end

      def _internal_expose_enum_column_(column_name, _column_type_, column, null: nil)
        column_null = null.nil? ? column.null : null

        array = column.sql_type_metadata.sql_type.include?('[]')

        ConsolePrint.log "#{column_name} field is not citext", level: :warn, tag: model_name if column.type != :citext

        enum_field(column_name, values: model.send(column_name).values, null: column_null, array:)
      end

      def _internal_expose_enum_argument_(column_name, _column_type_, column, required: nil)
        argument_required = required.nil? ? !column.null : required

        ConsolePrint.log "#{column_name} argument is not citext", level: :warn, tag: model_name if column.type != :citext

        enum_argument(column_name, values: model.send(column_name).values, required: argument_required)
      end

      def validations(column_hashes)
        invalid_prefixes = %w[raw credential password config]

        column_hashes.each_key do |name|
          invalid_prefixes.each do |prefix|
            if name.to_s.start_with?(prefix)
              ConsolePrint.log("is exposing #{name} #{prefix} column", level: :warn, tag: model_name)
            end
          end
        end
      end
    end
  end
end
