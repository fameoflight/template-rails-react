require 'rails_helper'

RSpec.describe Mutations::Model::UserOtpUpdate, type: :graphql do
  def execute(logged_user, object_user = nil)
    otp_key = ROTP::Base32.random_base32

    otp_code1 = ROTP::TOTP.new(otp_key)

    otp_code2 = ROTP::TOTP.new(otp_key)

    object_user ||= logged_user

    variables = {
      input: {
        objectId: graphql_id(object_user, Types::Model::UserType),
        otpKey: otp_key,
        otpCode1: otp_code1.now,
        otpCode2: otp_code2.now
      }
    }

    query = 'user { id, modelId } errors'

    graphql_execute_mutation('userOtpUpdate', variables:, query:, user: logged_user)
  end

  it 'basic' do
    user = create(:user)

    resp = execute(user)

    expect(resp[:object][:user][:modelId]).to eq(user.id)
  end

  it 'different user' do
    user = create(:user)

    object_user = create(:user)

    resp = execute(user, object_user)

    expect(resp[:object][:errors]).to eq(["You don't have permission to update this user."])
  end
end
