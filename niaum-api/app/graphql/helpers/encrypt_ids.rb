# frozen_string_literal: true

require 'bcrypt'

module Helpers
  module EncryptIds
    SEPERATOR = '&'

    ENCRYPTION_KEY = Rails.application.credentials[:graphql][:key].freeze
    ENCRYPTION_SECRET = Rails.application.credentials[:graphql][:secret].freeze

    def encrypted_object_id(object, graphql_type)
      parts = [object.class.to_s, graphql_type.to_s, object.id.to_s]

      parts.each do |part|
        raise ArgumentError, "type contain #{SEPERATOR}" if part.include?(SEPERATOR)
      end

      unique_name = parts.join(SEPERATOR)

      encrypt_and_sign(unique_name)
    end

    def object_from_encrypted_id(encrypted_id_with_hints)
      return nil if encrypted_id_with_hints.empty?

      encoded_id_with_hint = decrypt_and_verify(encrypted_id_with_hints)

      id_parts = encoded_id_with_hint.split(SEPERATOR)

      klazz = id_parts[0].safe_constantize

      graphql_klazz = id_parts[1].safe_constantize

      item_id = id_parts[2]

      model_object = klazz&.graphql_find_by(id: item_id)

      # Note(hemantv): we are doing this so id become inoperaable across different graphql type
      # usertype and miniusertype id can query either of those two
      # but we want to make sure underlying model is same

      # make sure model object is of type we expect it to be
      return nil if model_object && !model_object.is_a?(graphql_klazz.model)

      model_object&.graphql_class = graphql_klazz

      model_object
    end

    def encrypt_and_sign(plain_text)
      cipher = OpenSSL::Cipher.new('AES-256-CBC').encrypt
      cipher.key = ENCRYPTION_KEY
      cipher.iv = ENCRYPTION_SECRET
      s = cipher.update(plain_text) + cipher.final

      # s.unpack1('H*').upcase

      Base64.urlsafe_encode64(s).sub(/=+/, '')
    end

    def decrypt_and_verify(encrypted_text)
      # encrypted_text = [encrypted_text].pack('H*').unpack('C*').pack('c*')

      encrypted_text = Base64.urlsafe_decode64(encrypted_text)

      cipher = OpenSSL::Cipher.new('AES-256-CBC').decrypt
      cipher.key = ENCRYPTION_KEY
      cipher.iv = ENCRYPTION_SECRET
      cipher.update(encrypted_text) + cipher.final
    end
  end
end
