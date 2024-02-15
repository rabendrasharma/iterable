require 'rails_helper'
require 'webmock/rspec'
RSpec.describe BaseService do
  let(:user) { User.create(email: "test1@example.com", password: "password") }
  let(:event) { Event.create(event_name: "Test Event", user_id: user.id) }
  describe "call" do
    let(:end_point) { "/api/events/track" }
    let(:event_name) { event.event_name }
    let(:event_id) { event.id }

    it "makes a POST request to the specified end point with correct parameters" do
      expected_body_params = {
        email: user.email,
        userId: user.id,
        id: event_id,
        eventName: event_name
      }

      base_service_instance = BaseService.new
      allow(base_service_instance).to receive(:make_request).with(:post, end_point, expected_body_params)
      base_service_instance.call(end_point, user, event_name, event_id: event_id)
    end
  end

  describe "notification_email" do
    let(:end_point) { "/api/email/target" }

    it "makes a POST request to the specified end point with correct parameters" do
      expected_body_params = {
        allowRepeatMarketingSends: true,
        campaignId: 0,
        recipientEmail: user.email,
        recipientUserId: user.id,
        sendAt: anything
      }

      base_service_instance = BaseService.new
      allow(base_service_instance).to receive(:make_request).with(:post, end_point, expected_body_params)
      base_service_instance.notification_email(end_point, user)
    end
  end

  describe "make_request" do
    let(:end_point) { "/api/events/track" }
    let(:body_params) { { key: "value" } }

    it "makes a POST request to the specified end point with correct body parameters" do
      expected_url = "#{BaseService::ITERABLE_API_BASE_URL}#{end_point}"
      expected_headers = { 'Content-Type' => "application/json" }

      expect(WebMock).to receive(:enable!)
      stub_request(:post, expected_url)
        .with(body: body_params.to_json, headers: expected_headers)
        .to_return(body: 'success', status: 200)

      BaseService.new.make_request(:post, end_point, body_params)
    end
  end
end