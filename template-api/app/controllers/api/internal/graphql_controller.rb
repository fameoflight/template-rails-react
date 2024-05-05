# frozen_string_literal: true

module Api
  module Internal
    class GraphqlController < ApplicationController
      # If accessing from outside this domain, nullify the session
      # This allows for outside API access while preventing CSRF attacks,
      # but you'll have to authenticate your user separately
      # protect_from_forgery with: :null_session

      def execute
        variables = prepare_variables(params[:variables])
        query = params[:query]
        operation_name = params[:operationName]

        context = {
          user_context:,
          host: "#{request.protocol}#{request.host_with_port}",
          ip: request.remote_ip
        }

        begin
          result = TemplateApiSchema.execute(query, variables:, context:,
                                                    operation_name:)

          respond_with_format(result)
        rescue StandardError => e
          raise e unless Rails.env.development?

          handle_error_in_development(e)
        end
      end

      def append_info_to_payload(payload)
        super
        payload[:user] = user_context.real_user
        payload[:current_user] = user_context.current_user
      end

      private

      # Handle variables in form data, JSON body, or a blank value
      def prepare_variables(variables_param)
        case variables_param
        when String
          if variables_param.present?
            JSON.parse(variables_param) || {}
          else
            {}
          end
        when Hash
          variables_param
        when ActionController::Parameters
          variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
        when nil
          {}
        else
          raise ArgumentError, "Unexpected parameter: #{variables_param}"
        end
      end

      def handle_error_in_development(e)
        logger.error e.message
        logger.error e.backtrace.join("\n")

        render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} },
               status: :internal_server_error
      end
    end
  end
end
