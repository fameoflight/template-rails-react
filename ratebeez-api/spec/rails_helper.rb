# frozen_string_literal: true

require_relative 'support/factory_bot'

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require_relative 'support/vcr'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{Rails.root.join('spec/fixtures')}"

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end

# Note(Fix) for RSpec jobs until it's fixed
# https://github.com/rspec/rspec-rails/issues/2545

# TODO: is this still needed?
if Rails::VERSION::MAJOR >= 7
  require 'rspec/rails/version'

  RSpec::Core::ExampleGroup.module_eval do
    include ActiveSupport::Testing::TaggedLogging

    def name
      'foobar'
    end
  end
end
