require 'rails_helper'

RSpec.describe EventsRetrievalService do
  describe "#get_events" do
  	let(:user) { User.create(email: "demo@demo.com", password: "password")}
    let(:events) { [Event.create(event_name: "Event 1", user_id: user.id), Event.new(event_name: "Event 2", user_id: user.id)] }

    context "when events retrieval is successful" do
      it "returns all events" do
        allow_any_instance_of(BaseService).to receive(:make_request).and_return('success')
        allow(Event).to receive(:all).and_return(events)

        service = EventsRetrievalService.new
        retrieved_events = service.get_events

        expect(retrieved_events).to eq(events)
      end
    end

    context "when events retrieval fails" do
      it "logs an error and returns nil" do
        allow_any_instance_of(BaseService).to receive(:make_request).and_return('failure')
        allow(Event).to receive(:all).and_return(events)

        expect(Rails.logger).to receive(:error).with("Error getting events: Failed to get events")

        service = EventsRetrievalService.new
        retrieved_events = service.get_events

        expect(retrieved_events).to be_nil
      end
    end

    context "when an exception occurs" do
      it "logs an error and returns nil" do
        allow_any_instance_of(BaseService).to receive(:make_request).and_raise(StandardError.new("Something went wrong"))
        allow(Event).to receive(:all).and_return(events)

        expect(Rails.logger).to receive(:error).with("Error getting events: Something went wrong")

        service = EventsRetrievalService.new
        retrieved_events = service.get_events

        expect(retrieved_events).to be_nil
      end
    end
  end
end


