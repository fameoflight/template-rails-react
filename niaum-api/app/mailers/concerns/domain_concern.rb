# frozen_string_literal: true

module DomainConcern
  extend ActiveSupport::Concern

  included do
    default(
      from: "Picasso Support <support@#{Rails.application.credentials[:mail][:domain]}>",
      reply_to: "Picasso Support <support@#{Rails.application.credentials[:mail][:domain]}>",
      'Message-ID': lambda {
                      "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{Rails.application.credentials[:mail][:domain]}"
                    }
    )

    def domain
      host = Rails.application.credentials[:mail][:host]

      if Rails.env.production?
        "https://#{host}"
      else
        'http://localhost:3000'
      end
    end

    def full_url(path)
      assert path.start_with?('/'), 'path should start with /'

      "#{domain}#{path}"
    end

    def graphql_id(object, type, context: nil)
      PicassoApiSchema.id_from_object(object, type, context)
    end

    def blob_url(active_storage_blob)
      Rails.application.routes.url_helpers.rails_blob_url(active_storage_blob, host: domain)
    end

    def convert_recievers(recievers)
      recievers = [recievers] unless recievers.is_a?(Array)

      recievers = recievers.compact

      recievers.map do |reciever|
        convert_reciever(reciever)
      end.flatten.compact.uniq
    end

    def convert_reciever(reciever)
      assert !reciever.is_a?(Array), 'Reciever should not be an array'

      return reciever if reciever.is_a?(String)

      method_map = {
        'User' => :user_to,
        'Hub::Company' => :company_to,
        'Hub::CompanyEmployee' => :company_employee_to
      }

      method = method_map[reciever.class.name]

      assert method, "No method found for #{reciever.class.name}"

      send(method, reciever)
    end

    def user_to(user)
      assert user.is_a?(User), 'user should be a User'

      "#{user.name} <#{user.email}>"
    end

    def company_employee_to(reciever)
      assert reciever.is_a?(Hub::CompanyEmployee), 'Reciever should be a Hub::CompanyEmployee'

      include_invite_email = %w[accepted active].exclude?(reciever.status) && reciever.invite_email

      emails = ["#{reciever.name} <#{reciever.work_email}>"]

      emails << "#{reciever.name} <#{reciever.invite_email}>" if include_invite_email

      emails
    end

    def company_to(company)
      assert company.is_a?(Hub::Company), 'company should be a Hub::Company'

      company.admin_users.map { |user| user_to(user) }.join(', ')
    end
  end
end
