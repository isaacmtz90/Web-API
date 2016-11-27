# frozen_string_literal: true

class EventsLocatorAPI < Sinatra::Base
  # route to find groups based on coutry code and location text
  get "/#{API_VER}/groups/:countrycode/:locationtextquery/?" do
    countrycode = params[:countrycode]
    locationtext = params[:locationtextquery]

    response = Meetup::MeetupApi.get_groups(countrycode, locationtext)

    # Check if first result matches provided country code, 404 if not
    result = CheckResponse.call(response, countrycode, locationtext)

    content_type 'application/json'
    if result.success?
      response.to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end

  end

  # Body args (JSON) e.g.: {"url": "http://meetup.com/urlname"}
  post "/#{API_VER}/group/" do
    body_params = JSON.parse request.body.read
    meetup_group_url = body_params['url']

    content_type 'application/json'

    result = CheckDatabase.call(meetup_group_url) #if url already in DB, will throw error 422
    if result.success?
      meetup_group = CheckAPI.call(meetup_group_url) #if WebAPI cannot find url, will throw error 400
      if meetup_group.success?
        group = SaveGroupToDatabase.call(meetup_group.value) #if this cannot create group in DB, wil throw error 500
        if group.success?
          GroupRepresenter.new(group.value).to_json #display group in JSON
        else
          ErrorRepresenter.new(group.value).to_status_response
        end
      else
        ErrorRepresenter.new(meetup_group.value).to_status_response
      end
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
