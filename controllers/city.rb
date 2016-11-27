# frozen_string_literal: true

# Controller for the events
class EventsLocatorAPI < Sinatra::Base
  get "/#{API_VER}/cities/?" do
    result = FindCities.call
    CitiesRepresenter.new(result.value).to_json
  end

  post "/#{API_VER}/city/?" do
    result = LoadCityFromMeetup.call(request.body.read)
    if result.success?
      CityRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
