# frozen_string_literal: true

require 'colorized_string'

class ConsolePrint
  def self.log(message, level: nil, tag: nil, color: nil)
    new.log(message, level:, tag:, color:)
  end

  def self.debug(message, tag: nil, color: nil)
    new.debug(message, tag:, color:)
  end

  def self.error(message, tag: nil, color: nil)
    new.error(message, tag:, color:)
  end

  LEVEL_COLORS = {
    stdout: :default,
    debug: :light_blue,
    info: :blue,
    warn: :yellow,
    error: :light_red,
    fatal: :red
  }.freeze

  VALID_MODES = %i[default log].freeze

  def log(message, level: nil, tag: nil, color: nil)
    level ||= :debug

    tag ||= 'NO TAG'

    assert LEVEL_COLORS.key?(level), "Invalid level: #{level}"

    color ||= LEVEL_COLORS[level]

    assert ColorizedString.colors.include?(color), "Invalid color: #{color}"

    output_message = ColorizedString.new("[#{tag}] #{message}").colorize(color)

    if level == :stdout
      puts output_message # rubocop:disable Rails/Output
    else
      Rails.logger.send(level, output_message)
    end
  end

  def debug(message, tag: nil, color: nil)
    log(message, level: :stdout, tag:, color:)
  end

  def error(message, tag: nil, color: nil)
    log(message, level: :error, tag:, color:)
  end
end
