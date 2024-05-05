# frozen_string_literal: true

module ModelOnChangeCallbacks
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    # -- public interface --

    def self.before_change(attribute_name, opts = {})
      self._before_change_callbacks_ ||= Hash.new { |h, k| h[k] = {} }

      _setup_callback_(self._before_change_callbacks_, attribute_name, opts)
    end

    def self.after_change(attribute_name, opts = {})
      self._after_change_callbacks_ ||= Hash.new { |h, k| h[k] = {} }

      _setup_callback_(self._after_change_callbacks_, attribute_name, opts)
    end

    # -- private --

    class << self
      attr_accessor :_before_change_callbacks_, :_after_change_callbacks_

      def _validate_callback_opts_!(opts)
        valid_keys = %i[if unless proc method]

        invalid_keys = opts.keys - valid_keys

        assert invalid_keys.empty?, "invalid keys: #{invalid_keys}"

        assert opts[:proc] || opts[:method], 'must provide :proc or :method'

        assert opts[:proc].nil? || opts[:method].nil?, 'can not provide both :proc and :method'

        assert opts[:if].nil? || opts[:unless].nil?, 'can not provide both :if and :unless'
      end

      def _setup_callback_(callbacks, attribute_name, opts = {})
        _validate_callback_opts_!(opts)

        attribute_name_s = attribute_name.to_s

        # raise "can not find #{attribute_name_s} in #{self}"

        callbacks[attribute_name_s] = opts
      end
    end

    before_save :_run_before_change_callbacks_

    def _run_before_change_callbacks_
      _run_change_callbacks_(self.class._before_change_callbacks_, changes)
    end

    after_commit :_run_after_change_callbacks_

    def _run_after_change_callbacks_
      _run_change_callbacks_(self.class._after_change_callbacks_, saved_changes)
    end

    def _run_change_callbacks_(callbacks, changes_map)
      return if callbacks.nil?

      callbacks.each do |name, opts|
        next unless changes_map.include?(name)

        attr_changes = changes_map[name]

        run_callback = nil

        run_callback ||= instance_exec(&opts[:if]) if opts[:if]
        run_callback ||= !instance_exec(&opts[:unless]) if opts[:unless]

        run_callback ||= run_callback.nil?

        next unless run_callback

        previous = attr_changes[0]
        current = attr_changes[1]

        send(opts[:method], previous:, current:) if opts[:method]

        # previous_value, new_value
        instance_exec(previous, current, &opts[:proc]) if opts[:proc]
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
