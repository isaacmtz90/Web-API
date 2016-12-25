
# frozen_string_literal: true

# Input for cities
class NotificationRequestRepresenter < Roar::Decorator
  include Roar::JSON

  property :to
  property :message
end
