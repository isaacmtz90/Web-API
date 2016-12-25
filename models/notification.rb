# frozen_string_literal: true

# Represents a Notification's stored information
class Event < Sequel::Model
  many_to_one :event
end
