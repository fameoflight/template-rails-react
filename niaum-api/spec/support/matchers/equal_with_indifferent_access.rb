# frozen_string_literal: true

# match hashes with indifferent access
#
# example)
# expect({"key1" => 1, :key2 => 2}).to equal_with_indifferent_access(key1: 1, key2: 2)

RSpec::Matchers.define :equal_with_indifferent_access do |expected|
  match do |actual|
    actual.with_indifferent_access == expected.with_indifferent_access
  end

  failure_message do |actual|
    <<-ERROR
    expected: #{expected}
         got: #{actual}
    ERROR
  end

  failure_message_when_negated do |actual|
    <<-ERROR
    expected: value != #{expected}
         got:          #{actual}
    ERROR
  end
end

RSpec::Matchers.define :raise_assert do |message|
  supports_block_expectations

  match do |actual|
    expect { actual.call }.to raise_error(SolidAssert::AssertionFailedError, message)
  end

  failure_message do |actual|
    <<-ERROR
    expected: raise error, message: #{message}
         got: #{actual}
    ERROR
  end

  failure_message_when_negated do |actual|
    <<-ERROR
    expected: not raise error, message: #{message}
         got: #{actual}
    ERROR
  end
end
