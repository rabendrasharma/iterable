#frozen_string_literal: true

require 'webmock'
class BaseService
  include WebMock::API
  ITERABLE_API_BASE_URL = 'https://api.iterable.com'
  
  def call(end_point, user, event_name, event_id: 0)
    body_params = {
      "email": user.email,
      "userId": user.id,
      "id": event_id,
      "eventName": event_name
    }
    make_request(:post, end_point, body_params)
  end

  def notification_email(end_point, user)
    body_params = {
      "campaignId": 0,
      "recipientEmail": user.email,
      "recipientUserId": user.id,
      "sendAt": Time.zone.now,
      "allowRepeatMarketingSends": true
    }
    make_request(:post, end_point, body_params)
  end

  def make_request(method, end_point, body_params)
    url = ITERABLE_API_BASE_URL+end_point
    WebMock.enable!
    response = WebMock.stub_request(:post, url).with(body: body_params.to_json, headers: { 'Content-Type' => "application/json" }).and_return_json({body: 'success'})
    response_body = response.instance_variable_get(:@responses_sequences).map do |responses_sequence|
                      responses_sequence.instance_variable_get(:@responses).map(&:body)
                    end.flatten.first
    response_body
  end
end