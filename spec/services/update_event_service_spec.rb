require 'rails_helper'

RSpec.describe UpdateEventService do
  let(:user) { User.create(email: "test1@example.com", password: "password") }
  let(:event) { Event.create(event_name: "Test Event", user_id: user.id) }
  describe "#update_event" do
    context "when event update is successful" do
      it "updates event successfully" do
        allow_any_instance_of(BaseService).to receive(:call).and_return('success')
        user1 = User.create(email: "demo@demo1.com", password: "password")
        expect(UpdateEventService.new.call([user1.id], event.id, "Updated Event")).to be_truthy
      end
    end

    context "when event update fails" do
      it "returns false" do
        allow_any_instance_of(BaseService).to receive(:call).and_return('failure')
        expect(UpdateEventService.new.call([user.id], event.id, "Updated Event")).to be_falsey
      end
    end
  end
end