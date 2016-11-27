# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchByCity
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :find_city, lambda { |params|
    print params
    city = City.find(id: params[:id])
    if city
      Right(city)
    else
      Left(Error.new(:not_found, 'City not found'))
    end
  }

  register :search_events, lambda { |city|
    events = Event.filter(city_id: city.id.to_s)
    Right(Events.new(events))
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :find_city
      step :search_events
    end.call(params)
  end
end
