# frozen_string_literal: true

module Seed
  class Base
    attr_accessor :_internal_intialized, :logging

    def initialize(*_args, **kwargs)
      @logging = kwargs.fetch(:logging, true)

      @_internal_intialized = true
    end

    def seed
      assert @_internal_intialized, 'Seed::Base must be initialized before calling seed'

      PaperTrail.request(enabled: false) do
        run_seed
      end
    end

    protected

    def fixture_path(path)
      Rails.root.join('db/data/seed', path)
    end

    def json_fixture(path)
      JSON.parse(file_fixture(path))
    end

    def file_fixture(path)
      File.read(fixture_path(path))
    end

    def log(message, color: nil, tag: nil, level: nil)
      return unless logging

      tag ||= self.class.name.split('::').last

      level ||= :stdout

      ConsolePrint.log(message, level:, tag:, color:)
    end

    private

    def run_seed
      raise NotImplementedError
    end
  end
end
