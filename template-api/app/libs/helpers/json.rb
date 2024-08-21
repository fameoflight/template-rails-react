# frozen_string_literal: true

module Helpers
  module Json
    def json_to_text(json_data, indent = 0)
      output = +''

      case json_data
      when Hash
        json_data.each do |key, value|
          output << (('  ' * indent) + "#{key}:\n")
          output << json_to_text(value, indent + 1)
        end
      when Array
        json_data.each_with_index do |item, _index|
          output << ("#{'  ' * indent}- ") # Use a hyphen for array items
          output << json_to_text(item, indent + 1).lstrip # Remove leading space for nested items
        end
      else
        output << (('  ' * indent) + "#{json_data}\n")
      end

      output
    end
  end
end
