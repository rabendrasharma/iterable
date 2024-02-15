#frozen_string_literal: true

class Event < ApplicationRecord
  validates :event_name, presence: "event name can't be blank"
  has_many :event_users
  has_many :users, through: :event_users
end