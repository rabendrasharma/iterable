#frozen_string_literal: true

class UpdateEventService < BaseService
  def call(user_ids, event_id, event_name)
    begin
      event = Event.find(event_id)   
      user_ids.each do |user_id|
        user = User.find(user_id)
        unless user
          raise StandardError, "User not found with ID: #{user_id}"
        end
        unless event.users.include?(user)
          response = super('/api/events/track', user, event_name, event_id: event_id)
          if response == 'success'
            event.users << user
          else
            Rails.logger.error("Failed to track event for user: #{user_id}")
            return false
          end
        end
      end
      return true
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("Error updating event: #{e.message}")
      return false
    end
  end
end