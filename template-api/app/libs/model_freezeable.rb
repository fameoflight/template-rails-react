# frozen_string_literal: true

module ModelFreezeable
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    # -- public interface --

    def self.freeze_column(name, opts = {})
      _validate_freeze_opts!(opts)

      name_s = name.to_s

      self._frozen_columns ||= Hash.new { |h, k| h[k] = {} }
      self._frozen_columns[name_s] = opts
    end

    def self.freeze_columns(names, opts = {})
      names.each { |name| freeze_column(name, opts) }
    end

    def self.freeze_model(opts = {})
      _validate_freeze_opts!(opts)

      self._frozen_model_opts ||= []
      self._frozen_model_opts << opts
    end

    def self.freeze_destroy(opts = {})
      _validate_freeze_opts!(opts)

      self._frozen_destroy_opts ||= []
      self._frozen_destroy_opts << opts
    end

    # -- private --

    class << self
      attr_accessor :_frozen_model_opts, :_frozen_columns, :_frozen_destroy_opts

      def _validate_freeze_opts!(opts)
        valid_keys = %i[if unless message]

        keys = opts.keys

        invalid_keys = keys - valid_keys

        assert invalid_keys.empty?, "invalid keys: #{invalid_keys}"

        assert opts[:if] || opts[:unless], 'must provide :if or :unless'

        assert opts[:if].nil? || opts[:unless].nil?, 'can not provide both :if and :unless'
      end
    end

    validate :validate_frozen_columns
    validate :validate_frozen_model

    def validate_frozen_columns
      return if self.class._frozen_columns.nil?

      self.class._frozen_columns.each do |name, opts|
        next unless changed.include?(name)

        is_frozen = opts[:if].nil? ? !instance_exec(&opts[:unless]) : instance_exec(&opts[:if])

        message = opts[:message] || 'is immutable'

        errors.add name, message if is_frozen
      end
    end

    def validate_frozen_model
      return if self.class._frozen_model_opts.nil?

      self.class._frozen_model_opts.each do |opts|
        next if opts.empty?

        is_frozen = opts[:if].nil? ? !instance_exec(&opts[:unless]) : instance_exec(&opts[:if])

        next unless is_frozen

        message = opts[:message] || 'is immutable'

        (changed - (opts[:except_fields] || [])).each do |attribute|
          errors.add attribute, message
        end
      end
    end

    before_destroy :check_frozen_destroy

    def check_frozen_destroy
      destroy_opts = ((self.class._frozen_destroy_opts || []) + (self.class._frozen_model_opts || [])).flatten

      return if destroy_opts.empty?

      destroy_opts.each do |opts|
        next if opts.empty?

        is_frozen = opts[:if].nil? ? !instance_exec(&opts[:unless]) : instance_exec(&opts[:if])

        message = opts[:message] || "#{self} is immutable"

        errors.add :base, message if is_frozen
      end
    end
  end

  # rubocop:enable Metrics/BlockLength
end
