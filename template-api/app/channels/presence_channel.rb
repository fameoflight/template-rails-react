# frozen_string_literal: true

class PresenceChannel < ApplicationCable::Channel
  def subscribed
    room_id = params[:room_id]
    Rails.logger.info "👥 User #{current_user.name} joined presence for room: #{room_id}"
    
    stream_from "presence_#{room_id}"
    
    # Add user to online users for this room
    Redis.current.sadd("online_users_#{room_id}", current_user.id)
    
    # Broadcast that user joined
    BroadcastService.broadcast_user_joined(room_id, current_user)
    
    # Send current online users to the new subscriber
    online_user_ids = Redis.current.smembers("online_users_#{room_id}")
    online_users = User.where(id: online_user_ids)
    BroadcastService.broadcast_presence_update(room_id, online_users)
  end

  def unsubscribed
    room_id = params[:room_id]
    Rails.logger.info "👥 User #{current_user.name} left presence for room: #{room_id}"
    
    # Remove user from online users
    Redis.current.srem("online_users_#{room_id}", current_user.id)
    
    # Broadcast that user left
    BroadcastService.broadcast_user_left(room_id, current_user)
    
    # Send updated online users list
    online_user_ids = Redis.current.smembers("online_users_#{room_id}")
    online_users = User.where(id: online_user_ids)
    BroadcastService.broadcast_presence_update(room_id, online_users)
  end
end