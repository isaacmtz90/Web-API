
# frozen_string_literal: true

# Input for cities
class CityRequestRepresenter < Roar::Decorator
  include Roar::JSON

  property :city
  property :country_code
end
