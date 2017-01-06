
# frozen_string_literal: true

# Input for cities
class NotificationRequestRepresenter < Roar::Decorator
  include Roar::JSON

  property :to
  property :event_name
  property :from
  property :event_id
end
