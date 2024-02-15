#frozen_string_literal: true

class SendEmailNotificationService < BaseService
  def notification_email(user_id, event_name)
    begin
      user = User.find_by(id: user_id)
      unless user
        raise StandardError, "User not found with ID: #{user_id}"
      end
      
      response = super('/api/email/target', user)
      
      if response == 'success'
        NotificationMailer.notification_email(user.email, event_name).deliver_now
        return true
      else
        raise StandardError, "Failed to send email notification"
      end
    rescue StandardError => e
      Rails.logger.error("Error sending email notification: #{e.message}")
      return false
    end
  end
end