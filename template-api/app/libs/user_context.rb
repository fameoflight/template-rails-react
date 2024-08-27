# frozen_string_literal: true

class UserContext
  SUPER_USER_EMAILS = %w[fameoflight@gmail.com admin@test.com].freeze

  attr_reader :user, :super_user

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

  def object_user(object)
    return object.user if object.respond_to?(:user)

    return User.find_by(id: object.user_id) if object.respond_to?(:user_id)

    nil
  end

  def can_destroy?(object)
    # check if object has user_id or respond to user

    return true if object_user(object).nil?

    return true if object_user(object)&.id == @user&.id

    return true if @super_user.present?

    return true if super?

    false
  end
end
