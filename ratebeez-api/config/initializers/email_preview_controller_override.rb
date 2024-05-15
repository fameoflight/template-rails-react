# frozen_string_literal: true

if Rails.env.development?
  Rails.configuration.to_prepare do
    module Rails # rubocop:disable Lint/ConstantDefinitionInBlock
      class MailersController
        around_action :skip_bullet

        def skip_bullet
          Bullet.enable = false
          yield
        ensure
          Bullet.enable = true
        end
      end
    end
  end
end
