#frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notification_email(user_email, event_name)
    @event_name = event_name
    mail(to: user_email, subject: 'Notification Email')
  end
end