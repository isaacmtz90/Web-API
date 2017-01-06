
# frozen_string_literal: true

# Input for cities
class SMSSendRequestRepresenter < Roar::Decorator
  include Roar::JSON

  property :to
  property :message
  property :url
end
