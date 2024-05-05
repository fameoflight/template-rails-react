# frozen_string_literal: true

Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy

# delete flash middleware

Rails.application.config.middleware.delete ActionDispatch::Flash
