#frozen_string_literal: true

class EventsRetrievalService < BaseService
  def get_events
    begin
      events = Event.all
      # assuming 'api/events' is the end point to get all events
      response = make_request(:get, 'api/events', events.to_json)
      if response == 'success'
        return events
      else
        raise StandardError, "Failed to get events"
      end
    rescue StandardError => e
      Rails.logger.error("Error getting events: #{e.message}")
      return nil
    end
  end
end