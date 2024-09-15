# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::DiscardObject, type: :graphql do
  let(:user) { create(:user) }
  let(:model_attachment) { create(:model_attachment, owner: user) }
  let(:user_key) { create(:user_key, user:) }

  def execute_query(object, object_type, current_user = nil)
    object_id = graphql_id(object, object_type)
    variables = {
      input: {
        objectId: object_id
      }
    }
    query = 'errors'
    graphql_execute_mutation('discardObject', variables:, query:, user: current_user)
  end

  context 'when discarding a ModelAttachment' do
    it 'discards the object when user has permission' do
      resp = execute_query(model_attachment, Types::Model::ModelAttachmentType, user)
      expect(resp[:object]['errors']).to be_empty
      expect(model_attachment.reload.discarded?).to be true
    end

    it 'fails when user does not have permission' do
      other_user = create(:user)
      resp = execute_query(model_attachment, Types::Model::ModelAttachmentType, other_user)
      expect(resp[:object]['errors']).to include("You don't have permission to destroy #{model_attachment}")
      expect(model_attachment.reload.discarded?).to be false
    end
  end

  it 'fails with invalid object class' do
    invalid_object = create(:user)
    resp = execute_query(invalid_object, Types::Model::UserType, user)
    expect(resp[:object]['errors']).to include("Invalid object class: #{invalid_object.class}")
  end

  it 'fails when no user is provided' do
    resp = execute_query(model_attachment, Types::Model::ModelAttachmentType)
    expect(resp[:object]['errors']).to include("You don't have permission to destroy #{model_attachment}")
  end
end
