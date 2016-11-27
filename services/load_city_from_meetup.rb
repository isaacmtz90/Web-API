# frozen_string_literal: true

# Loads data from Facebook group to database
class LoadCityFromMeetup
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  CITY_TEXT_REGEXP = %r{\"\D\"}

  register :validate_request_json, lambda { |request_body|
    begin
      print request_body
      url_representation = CityRequestRepresenter.new(UrlRequest.new)
      Right(url_representation.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, 'URL could not be resolved'))
    end
  }

  register :validate_request_url, lambda { |body_params|
    print body_params
    if (city = body_params['city'] || body_params['country_code']).nil?
      Left(Error.new(:cannot_process, 'Could not load city/country of request'))
    else
      Right(city: city, country: body_params['country_code'])
    end
  }

  register :retrieve_meetup_events_bycity, lambda { |params|
    print params
    if (city_ev = Meetup::LocatedEvents.new(city: params[:city],
                                            country: params[:country],
                                            topic: 'none')).nil?
      Left(Error.new(:cannot_process, 'City doesnt contain events'))
    else
      Right(city: params[:city], country: params[:country], events: city_ev.events)
    end
  }

  register :validate_database_existence, lambda { |prm|
    if City.find(country_code: prm[:country], name: prm[:city])
      Left(Error.new(:cannot_process, 'City already on DB'))
    else
      Right(city: prm[:city], country: prm[:country])
    end
  }
  # TODO: Change to get city from meetup API
  register :create_city_and_events, lambda { |prm|
    city = City.create(name: prm[:city], country_code: prm[:country])
    prm[:events].each do |event|
      write_city_event(city, event)
    end
    Right(city)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :validate_request_url
      step :validate_database_existence
      step :retrieve_meetup_events_bycity
      step :create_city_and_events
    end.call(params)
  end

  def self.write_city_event(city, event)
    city.add_event(
      event_name:          event.name,
      origin:              'meetup',
      status:              event.status,
      venue:               event.venue,
      time:                event.time,
      lat:                 event.location&.lat,
      lon:                 event.location&.lon
    )
  end
end
