module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Extract auth headers from the request
      access_token = request.params['access-token'] || request.headers['access-token']
      client = request.params['client'] || request.headers['client']
      uid = request.params['uid'] || request.headers['uid']

      Rails.logger.info "🔑 ActionCable auth attempt - access_token: #{access_token.present?}, client: #{client.present?}, uid: #{uid}"

      if access_token.present? && client.present? && uid.present?
        user = User.find_by(uid: uid)
        Rails.logger.info "👤 Found user: #{user&.id}"
        
        if user && user.valid_token?(access_token, client)
          Rails.logger.info "✅ ActionCable connection authorized for user: #{user.id}"
          user
        else
          Rails.logger.warn "❌ ActionCable token validation failed"
          reject_unauthorized_connection
        end
      else
        Rails.logger.warn "❌ ActionCable missing auth parameters"
        reject_unauthorized_connection
      end
    end
  end
end
