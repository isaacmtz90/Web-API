# frozen_string_literal: true

# gets a city's data from meetup
class SearchCityFromMeetup
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin


  register :retrieve_city_bycountry, lambda { |search_params|
    begin
      city_ev = Meetup::MeetupApi.get_cities_by_country(search_params['country_code'])
      puts city_ev
      if city_ev.nil?
        Left(Error.new(:cannot_process, 'Cant read cities for that country code'))
      else
        # Right(city_ev)
        Right({cities: city_ev['results'], search: search_params['name']})
      end
    rescue
      Left(Error.new(:cannot_process, 'Cant retrieve cities from meetup'))
    end
  }

  register :return_selected_city, lambda { |params|
    begin
      params['cities'].each do |city|
        Right(city) if city.city.casecmp(params['name']).zero?
      end
    rescue
      Left(Error.new(:not_found, 'Cant find a city with the specified name'))
    end
  }


  # # TODO: Change to get city from meetup API
  # register :create_city_and_events, lambda { |prm|
  #   city = City.create(name: prm[:city], country_code: prm[:country])
  #   prm[:events].each do |event|
  #     write_city_event(city, event, prm[:topic])
  #   end
  #   Right(city)
  # }

  def self.call(params)
    # print params
    Dry.Transaction(container: self) do
      step :retrieve_city_bycountry
      step :return_selected_city
    end.call(params)
  end

  # def self.write_city_event(city, event, topic)
  #   city.add_event(
  #     event_name:          event.name,
  #     origin:              'meetup',
  #     url:                 event.url,
  #     status:              event.status,
  #     venue:               event.venue,
  #     time:                Time.at(event.time / 1000),
  #     lat:                 event.location&.lat,
  #     topic:               event.topic,
  #     description:         event.description,
  #     lon:                 event.location&.lon
  #   )
  # end
end
