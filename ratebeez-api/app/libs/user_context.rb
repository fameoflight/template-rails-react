# frozen_string_literal: true

class UserContext
  SUPER_USER_EMAILS = %w[fameoflight@gmail.com].freeze

  attr_reader :user

  def initialize(init_user)
    @user = init_user

    @super_user = SuperUser.find_by(user_id: @user&.id)
  end

  def real_user
    @user
  end

  def current_user
    @super_user&.spoof_user || @user
  end

  def spoof?
    @super_user&.spoof_user.present?
  end

  def super?
    SUPER_USER_EMAILS.include?(@user&.email)
  end

  def file_size_limit
    10.megabytes
  end

  def file_type_allowed?(_content_type)
    true
  end
end
