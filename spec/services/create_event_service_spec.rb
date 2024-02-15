require 'rails_helper'

RSpec.describe CreateEventService do
  let(:user) { User.create(email: "test1@example.com", password: "password") }

  describe "#call" do
    context "when event creation is successful" do
      it "creates an event and returns it" do
        allow_any_instance_of(BaseService).to receive(:call).and_return('success')
        event_name = "Test Event"
        expect(Event).to receive(:create).with(user_id: user.id, event_name: event_name, email: user.email).and_return(true)

        service = CreateEventService.new
        event = service.call(user, event_name)
        expect(event).to be_truthy
      end
    end

    context "when event creation fails" do
      it "logs an error and returns false" do
        allow_any_instance_of(BaseService).to receive(:call).and_return('failure')
        event_name = "Test Event"

        expect(Rails.logger).to receive(:error).with("Error creating event: Failed to create event")

        service = CreateEventService.new
        event = service.call(user, event_name)
        expect(event).to be_falsey
      end
    end

    context "when an exception occurs" do
      it "logs an error and returns false" do
        allow_any_instance_of(BaseService).to receive(:call).and_raise(StandardError.new("Something went wrong"))
        event_name = "Test Event"

        expect(Rails.logger).to receive(:error).with("Error creating event: Something went wrong")

        service = CreateEventService.new
        event = service.call(user, event_name)
        expect(event).to be_falsey
      end
    end
  end
end
