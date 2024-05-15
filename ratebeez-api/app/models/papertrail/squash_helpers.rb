# frozen_string_literal: true

module Papertrail
  module SquashHelpers
    extend ActiveSupport::Concern

    IGONORABLE_KEYS = %w[updated_at created_at].freeze

    class NonConsecutiveChanges < StandardError
    end

    class DifferentItem < StandardError
    end

    def squash_versions(unprocessed_versions)
      unprocessed_versions = unprocessed_versions.to_a unless unprocessed_versions.is_a? Array

      unprocessed_versions = unprocessed_versions.sort_by(&:created_at)

      version1 = unprocessed_versions.first

      # merge unprocessed versions into one change

      begin
        (1...unprocessed_versions.count).each do |idx|
          version1 = squash_version_instances(version1, unprocessed_versions[idx])
        end
      rescue StandardError => e
        ::Rails.logger.error "Failed to squash version #{e}"

        # raise e unless ::Rails.env.production?
      end
    end

    def squash_version_instances(from_version, to_version)
      copy_attributes(from_version, to_version)

      to_version.save!

      from_version.delete

      to_version
    end

    private

    def copy_attributes(from_version, to_version)
      if from_version.has_attribute?(:object)
        from_version.reify # this is just here for testing if the version is still 'reifiable'
      end

      raise DifferentItem if from_version.item_type != to_version.item_type

      raise DifferentItem if from_version.item_id != to_version.item_id

      raise DifferentItem if from_version.class != to_version.class

      # algorithm
      #   - turn to_version into a single version that represent the change from prior to from_version up to after to_version
      # the object represent the OLD version, the OLD version is the version it was at from_version change
      to_version.object = from_version.object if from_version.has_attribute?(:object)

      to_version.object_changes = _internal_merge_changeset(from_version, to_version)

      # copy over whodunit
      to_version.whodunnit = to_version.whodunnit || from_version.whodunnit
    end

    def _internal_merge_changeset(from_version, to_version)
      merged_changes = from_version.changeset

      to_version.changeset.each do |key, change|
        # this change doesn't exist in previous version
        unless merged_changes[key]
          merged_changes[key] = change
          next
        end

        # old change key => [a,b1]
        # new change key => [b2,c]

        # these are non consective version, merging them will break version history

        unless merged_changes[key][1] == change[0]
          unless IGONORABLE_KEYS.include? key
            raise NonConsecutiveChanges,
                  "#{key} #{merged_changes[key][1]} #{change[0]}"
          end
        end

        if merged_changes[key][0] == change[1]
          # value didn't change between from_version and version 2, delete the change
          merged_changes.delete(key)
        else
          merged_changes[key] = [merged_changes[key][0], change[1]]
        end
      end

      merged_changes
    end
  end
end
