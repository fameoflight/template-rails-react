# frozen_string_literal: true

namespace :demo do
  desc "Create demo notifications for testing"
  task notifications: :environment do
    puts "Creating demo notifications..."
    
    # Get the first user, or create one if none exists
    user = User.first
    unless user
      puts "No users found. Please create a user first."
      exit
    end
    
    puts "Creating notifications for user: #{user.email}"
    
    # Create various types of notifications
    notifications = [
      {
        title: "Welcome to the platform!",
        message: "Thanks for joining us. Explore all the features we have to offer.",
        notification_type: "success"
      },
      {
        title: "New message received",
        message: "You have a new message in the chat room 'General'.",
        notification_type: "message"
      },
      {
        title: "System maintenance scheduled",
        message: "We'll be performing maintenance tonight from 2-4 AM EST.",
        notification_type: "warning"
      },
      {
        title: "Profile updated successfully",
        message: "Your profile information has been updated.",
        notification_type: "success"
      },
      {
        title: "Security alert",
        message: "New login detected from a different device.",
        notification_type: "warning"
      },
      {
        title: "Achievement unlocked!",
        message: "You've sent your first message. Keep it up!",
        notification_type: "achievement"
      },
      {
        title: "Reminder: Complete your profile",
        message: "Don't forget to add your profile picture and bio.",
        notification_type: "reminder"
      },
      {
        title: "Connection error resolved",
        message: "The network connection issue has been resolved.",
        notification_type: "success"
      }
    ]
    
    notifications.each_with_index do |notif, index|
      notification = BroadcastService.create_and_broadcast_notification(
        user,
        notif[:title],
        notif[:message],
        notif[:notification_type]
      )
      
      # Mark some as read for variety
      if index.even?
        notification.mark_as_read!
      end
      
      puts "Created: #{notif[:title]}"
      
      # Add some delay to make created_at times different
      sleep(0.1)
    end
    
    puts "Demo notifications created successfully!"
    puts "Unread count: #{user.notifications.unread.count}"
    puts "Total count: #{user.notifications.count}"
  end
end