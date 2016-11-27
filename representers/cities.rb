# frozen_string_literal: true
require_relative 'event'
require_relative 'events'
require_relative 'city'

# Represents overall group information for JSON API output
class CitiesRepresenter < Roar::Decorator
  include Roar::JSON

  collection :cities, extend: CityRepresenter, class: City
end
