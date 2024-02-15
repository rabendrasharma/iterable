#frozen_string_literal: true

class CreateEventService < BaseService
  def call(user, event_name)
    begin
      response = super('/api/events/track', user, event_name)
      if response == 'success'
        event = Event.create(user_id: user.id, event_name: event_name, email: user.email)
        return event
      else
        raise StandardError, "Failed to create event"
      end
    rescue StandardError => e
      Rails.logger.error("Error creating event: #{e.message}")
      return false
    end
  end
end