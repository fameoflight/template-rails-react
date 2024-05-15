# frozen_string_literal: true

require 'colorize'

class SpecCoverage
  def initialize
    init_simple_cov
  end

  def init_simple_cov
    puts 'Code Coverage enabled'.colorize(:green)

    require 'simplecov'
    require 'simplecov-console'

    SimpleCov::Formatter::Console.max_rows = 25
    SimpleCov::Formatter::Console.max_lines = 10
    SimpleCov::Formatter::Console.output_style = 'block'

    if ENV['CI']
      puts 'CI detected, generating SimpleFormatter report'.colorize(:green)

      SimpleCov.formatter = SimpleCov::Formatter::Console
    else
      require 'simplecov-tailwindcss'

      SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
        [
          SimpleCov::Formatter::TailwindFormatter,
          SimpleCov::Formatter::Console
        ]
      )
    end

    SimpleCov.start 'rails' do
      add_filter '/spec/'
      add_filter '/config/'
      add_group 'Controllers', 'app/controllers'
      add_group 'Models', 'app/models'
      add_group 'GraphQL', 'app/graphql'
    end

    SimpleCov.at_exit do
      SimpleCov.result.format!

      if ENV['CI']
        # noop
      else
        puts 'Code Coverage result at ./coverage/index.html'.colorize(:green)
      end

      # exec 'open ./coverage/index.html'
    end
  end
end

SpecCoverage.new if ENV['COV'] || ENV['CI']
