# frozen_string_literal: true

# Represents overall event information for JSON API output
class EventRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :group_id, type: String
  property :event_name
  property :city
  property :lat
  property :lon
  property :time, type: String
  property :country_code
  property :type
end
