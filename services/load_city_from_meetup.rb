# frozen_string_literal: true

# Loads data from Facebook group to database
class LoadCityFromMeetup
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  CITY_TEXT_REGEXP = %r{\"\D\"}

  register :get_city_from_meetup, lambda { |request_body|
    city = SearchCityFromMeetup.call(request_body)
    if city.success?
      city_obj = city.value[0]
      city_obj['city'].capitalize!
      city_obj['country'].upcase!
      Right(city: city_obj['city'], country: city_obj['country'],
            lon: city_obj['lon'], lat: city_obj['lat'], topic: 'none')
    else
      Left(Error.new(:cannot_process, 'Could not find on meetup'))
    end
  }

  # register :validate_request_json, lambda { |request_body|
  #   begin
  #     url_representation = CityRequestRepresenter.new(UrlRequest.new)
  #     Right(url_representation.from_json(request_body))
  #   rescue
  #     Left(Error.new(:bad_request, 'URL could not be resolved'))
  #   end
  # }
  #
  # register :validate_request_url, lambda { |body_params|
  #   # print body_params
  #   if (city = body_params['city'] || body_params['country_code']).nil?
  #     Left(Error.new(:cannot_process, 'Could not load city/country of request'))
  #   else
  #     topic = body_params.member?(:topic) ? body_params[:topic] : 'none'
  #     Right(city: city, country: body_params['country_code'], topic: topic)
  #   end
  # }

  register :retrieve_meetup_events_bycity, lambda { |params|
    # print params
    begin
      city_ev = Meetup::LocatedEvents.new(city: params[:city],
                                          country: params[:country],
                                          topic: params[:topic])
    rescue
      Left(Error.new(:cannot_process, 'City doesnt contain events'))
    else
      if city_ev.nil?
        Left(Error.new(:cannot_process, 'City doesnt contain events'))
      else
        Right(city: params[:city], country: params[:country], lat: params[:lat],
              events: city_ev.events, topic: params[:topic], lon: params[:lon])
      end
    end
  }

  register :validate_database_existence, lambda { |prm|
    if City.find(country_code: prm[:country], name: prm[:city])
      Left(Error.new(:cannot_process, 'City already on DB'))
    else
      Right(city: prm[:city], country: prm[:country], topic: prm[:topic],
            lon: prm[:lon], lat: prm[:lat])
    end
  }
  # TODO: Change to get city from meetup API
  register :create_city_and_events, lambda { |prm|
    city = City.create(name: prm[:city], country_code: prm[:country],
                       lon: prm[:lon], lat: prm[:lat])
    prm[:events].each do |event|
      write_city_event(city, event, prm[:topic])
    end
    Right(city)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :get_city_from_meetup
      step :validate_database_existence
      step :retrieve_meetup_events_bycity
      step :create_city_and_events
    end.call(params)
  end

  def self.write_city_event(city, event, topic)
    city.add_event(
      event_name:          event.name,
      origin:              'meetup',
      url:                 event.url,
      status:              event.status,
      venue:               event.venue,
      time:                Time.at(event.time / 1000),
      lat:                 event.location&.lat,
      topic:               event.topic,
      description:         event.description,
      lon:                 event.location&.lon
    )
  end
end
