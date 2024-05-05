# frozen_string_literal: true

SolidAssert.enable_assertions

Object.class_eval do
  NULL_MARKER = 'null' # rubocop:disable Lint/ConstantDefinitionInBlock

  def numeric?(value)
    !Float(value).nil?
  rescue StandardError
    false
  end
end
