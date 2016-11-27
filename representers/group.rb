# frozen_string_literal: true

# Represents overall event information for JSON API output
class GroupRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :group_name
  property :event_name
  property :city
  property :country_code
end
