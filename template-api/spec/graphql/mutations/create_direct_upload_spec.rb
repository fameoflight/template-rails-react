# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateDirectUpload, type: :graphql do
  it 'no user' do
    img_avatar = fixture_file_upload('img_avatar.png')

    variables = {
      input: {
        filename: 'avatar.png',
        contentType: 'image/png',
        byteSize: File.size(img_avatar.path),
        checksum: Digest::MD5.base64digest(File.read(img_avatar.path))
      }
    }

    query = 'directUpload { directUploadUrl }'

    resp = graphql_execute_mutation('createDirectUpload', variables:, query:)

    expect(resp[:errors][0]['message']).to eq('An object of type Mutation was hidden due to permissions')
  end

  it 'with user' do
    user = create(:user)

    img_avatar = fixture_file_upload('img_avatar.png')

    variables = {
      input: {
        filename: 'avatar.png',
        contentType: 'image/png',
        byteSize: File.size(img_avatar.path),
        checksum: Digest::MD5.base64digest(File.read(img_avatar.path))
      }
    }

    query = 'directUpload { id, signedId, directUploadUrl, publicUrl }'

    resp = graphql_execute_mutation('createDirectUpload', variables:, query:, user:)

    expect(resp[:object]['directUpload']).not_to be_nil

    expect(resp[:object]['directUpload']['directUploadUrl']).not_to be_nil
    expect(resp[:object]['directUpload']['publicUrl']).not_to be_nil
  end
end
