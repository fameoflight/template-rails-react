# frozen_string_literal: true

require Rails.root.join('db/data/seed/base.rb')

Rails.root.join('db/data/seed').glob('*rb').each do |file|
  require file
end

namespace :data do
  desc 'Seed Data'

  task all: :environment do
    # is mac os x

    puts 'Detected Mac OS X' if RUBY_PLATFORM.include?('darwin')

    # all klasses that inherit from Seed::Base

    klasses = Seed.constants.map { |c| Seed.const_get(c) }.select { |c| c.is_a?(Class) && c < Seed::Base }

    klasses.each do |klass|
      puts "Seeding #{klass}... "

      klass.new.seed

      puts '-' * 80
    end
  end
end
