# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "🎯 ChatChannel subscribed for room: #{params[:room_id]}"
    stream_from "chat_#{params[:room_id]}"
  end

  def unsubscribed
    Rails.logger.info "🎯 ChatChannel unsubscribed from room: #{params[:room_id]}"
    
    # Clear typing indicator when user disconnects
    BroadcastService.broadcast_typing(params[:room_id], current_user, is_typing: false)
  end

  def start_typing(data)
    Rails.logger.info "⌨️ #{current_user.name} started typing in room: #{params[:room_id]}"
    BroadcastService.broadcast_typing(params[:room_id], current_user, is_typing: true)
  end

  def stop_typing(data)
    Rails.logger.info "⌨️ #{current_user.name} stopped typing in room: #{params[:room_id]}"
    BroadcastService.broadcast_typing(params[:room_id], current_user, is_typing: false)
  end
end