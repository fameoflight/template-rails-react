# frozen_string_literal: true

module ModelShortId
  extend ActiveSupport::Concern

  SHORT_ID_REGEX = /^[-a-z0-9_.]*$/

  included do
    validates :short_id, presence: true, uniqueness: true,
                         format: { with: SHORT_ID_REGEX, multiline: true }

    def self.find_short_id(short_id, previous_short_id: nil)
      short_ids = [short_id, previous_short_id].compact

      where(short_id: short_ids).first
    end

    def self.find_config(config)
      config = config.with_indifferent_access

      short_id = config[:short_id]
      previous_short_id = config[:previous_short_id]

      assert short_id.present?, 'short_id is required'

      find_short_id(short_id, previous_short_id:)
    end
  end
end
