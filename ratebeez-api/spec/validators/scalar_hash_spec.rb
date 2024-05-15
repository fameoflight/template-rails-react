# frozen_string_literal: true

require 'rails_helper'

class Dummy
  include ActiveModel::Validations
end

RSpec.describe Validators::ScalarHash do
  let(:validator) { described_class.new({ attributes: ['hello'] }) }

  def validate(value)
    Dummy.new.tap do |d|
      validator.validate_each(d, :attribute, value)
    end.errors[:attribute]
  end

  it 'is valid' do
    expect(validate({})).to be_empty
  end

  it 'is invalid' do
    expect(validate([])).to eq(['must be a hash'])
  end
end
