# frozen_string_literal: true

require_relative 'support/spec_coverage'
require_relative 'support/webmock'

require 'test_prof' if ENV['PROF'] || ENV['TEST_RUBY_PROF'] || ENV['TEST_STACK_PROF']

# Profiling Commands
# TEST_RUBY_PROF=1 rspec
# or
# TEST_RUBY_PROF=call_stack rspec
# # or
# TEST_STACK_PROF=1 rspec
# or
# To activate RSpecDissect use RD_PROF environment variable:
# or in example
# it "is doing heavy stuff", :rprof do
#   # ...
# end

# spec helpers
Dir["#{File.dirname(__FILE__)}/support/spec_helpers/*.rb"].each { |file| require file }

# matchers
Dir["#{File.dirname(__FILE__)}/support/matchers/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include RequestHelpers,  type: :controller
  config.include RequestHelpers,  type: :request

  config.include GraphqlSpecHelpers, type: :graphql
  config.include CommonSpecHelpers

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.before do
    ActiveStorage::Current.url_options = { host: 'localhost:5001' }
  end

  #   config.profile_examples = 10

  config.order = :random
end
