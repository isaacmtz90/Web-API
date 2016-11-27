# frozen_string_literal: true

# Represents overall event information for JSON API output
class EventRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :city_id, type: String
  property :event_name
  property :event_url
  property :origin
  property :status
  property :venue
  property :lat
  property :lon
  property :time, type: String
end
