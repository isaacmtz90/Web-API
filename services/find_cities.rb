
# frozen_string_literal: true

# Loads data from Facebook group to database
class FindCities
  extend Dry::Monads::Either::Mixin

  def self.call
    if (cities = City.all).nil?
      Left(Error.new(:not_found, 'No cities found'))
    else
      Right(Cities.new(cities))
    end
  end
end
