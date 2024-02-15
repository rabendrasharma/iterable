require 'rails_helper'

RSpec.describe SendEmailNotificationService do
  describe "#notification_email" do
    let(:user) { User.create(email: "test@example.com", password: "password") }
    let(:event) { Event.create(event_name: "test event", user_id: user.id)}
    let(:event_name) { event.event_name}

    context "when user exists and email notification is successfully sent" do
      it "sends email notification and returns true" do
        allow(User).to receive(:find_by).with(id: user.id).and_return(user)
        allow_any_instance_of(BaseService).to receive(:call).and_return('success')
        expect(NotificationMailer).to receive_message_chain(:notification_email, :deliver_now)

        service = SendEmailNotificationService.new
        result = service.notification_email(user.id, event_name)

        expect(result).to be_truthy
      end
    end

    context "when user does not exist" do
      it "logs an error and returns false" do
        allow(User).to receive(:find_by).with(id: user.id).and_return(nil)
        expect(Rails.logger).to receive(:error).with("Error sending email notification: User not found with ID: #{user.id}")

        service = SendEmailNotificationService.new
        result = service.notification_email(user.id, event_name)

        expect(result).to be_falsey
      end
    end
  end
end
