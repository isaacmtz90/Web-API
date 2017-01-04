# frozen_string_literal: true
require_relative 'city'
require_relative 'event'

# Represents overall group information for JSON API output
class EventsRepresenter < Roar::Decorator
  include Roar::JSON
  collection :events, extend: EventRepresenter, class: Event
end
