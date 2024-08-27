# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::CreateDirectUpload, type: :graphql do
  it 'no user' do
    resp = upload_file_fixture('img_avatar.png')

    expect(resp[:errors][0]['message']).to eq('An object of type Mutation was hidden due to permissions')
  end

  it 'with user' do
    user = create(:user)

    resp = upload_file_fixture('img_avatar.png', user:)

    expect(resp[:object]['directUpload']).not_to be_nil

    expect(resp[:object]['directUpload']['directUploadUrl']).not_to be_nil
    expect(resp[:object]['directUpload']['publicUrl']).not_to be_nil
  end
end
