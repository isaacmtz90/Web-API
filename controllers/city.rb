# frozen_string_literal: true

# Controller for the events
class EventsLocatorAPI < Sinatra::Base
  get "/#{API_VER}/cities/?" do
    result = FindCities.call
    CitiesRepresenter.new(result.value).to_json
  end

  post "/#{API_VER}/city/?" do
    begin
      result = AddCityWorker.perform_async(request.body.read)
    rescue => e
      puts "ERROR: #{e}"
    end
    puts "WORKER: #{result}"
    [202, 'success']
  end

  # post "/#{API_VER}/cities/search/?" do
  #   begin
  #     result = AddCityWorker.perform_async(request.body.read)
  #   rescue => e
  #     puts "ERROR: #{e}"
  #   end
  #   puts "WORKER: #{result}"
  #   [202, { channel_id: channel_id }.to_json]

    # result = SearchCityFromMeetup.call(request.body.read)
    # if result.success?
    #   result.value.to_json
    # else
    #   ErrorRepresenter.new(result.value).to_status_response
    # end
  # end
end
