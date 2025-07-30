# frozen_string_literal: true

class GraphqlChannel < ApplicationCable::Channel
  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    Rails.logger.info "GraphQL Channel received: #{data}"
    
    query = data['query']
    variables = data['variables'] || {}
    operation_name = data['operationName']
    context = {
      current_user: current_user,
      subscription_id: data['subscriptionId'],
      channel: self
    }

    result = TemplateApiSchema.execute(
      query: query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )

    payload = {
      result: result.to_h,
      more: result.subscription?
    }

    # Store subscription ID if this is a subscription
    if result.subscription?
      @subscription_ids << context[:subscription_id]
      Rails.logger.info "Stored subscription ID: #{context[:subscription_id]}"
    end

    Rails.logger.info "📡 GraphQL result.to_h: #{result.to_h}"
    Rails.logger.info "📡 GraphQL result errors: #{result.to_h['errors']}"
    Rails.logger.info "📡 Transmitting payload: #{payload}"
    Rails.logger.info "📡 ActionCable connection state: #{connection.present? ? 'connected' : 'disconnected'}"
    
    begin
      transmit(payload)
      Rails.logger.info "📡 ✅ Payload transmitted successfully"
    rescue => e
      Rails.logger.error "📡 ❌ Failed to transmit payload: #{e.message}"
      Rails.logger.error "📡 ❌ Error: #{e.backtrace.first(5).join(', ')}"
    end
  end

  def unsubscribed
    @subscription_ids.each do |subscription_id|
      TemplateApiSchema.subscriptions.delete_subscription(subscription_id)
    end
  end
end