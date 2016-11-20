# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'meetupevents'
require_relative '../config/environment.rb'

class EventsLocatorAPI < Sinatra::Base
  # route to find groups based on coutry code and location text
  get "/#{API_VER}/groups/:countrycode/:locationtextquery/?" do
    countrycode = params[:countrycode]
    locationtext = params[:locationtextquery]

    response = Meetup::MeetupApi.get_groups(countrycode, locationtext)

    # Check if first result matches provided country code, 404 if not
    CheckResponse.call(response, countrycode, locationtext)

    content_type 'application/json'
    response.to_json
  end

  # Body args (JSON) e.g.: {"url": "http://meetup.com/urlname"}
  post "/#{API_VER}/group/" do
    body_params = JSON.parse request.body.read
    meetup_group_url = body_params['url']

    CheckDatabase.call(meetup_group_url) #if url already in DB, will throw error 422
    meetup_group = CheckAPI.call(meetup_group_url) #if WebAPI cannot find url, will throw error 400

    group = SaveGroupToDatabase.call(meetup_group) #if this cannot create group in DB, wil throw error 500

    content_type 'application/json'
    GroupRepresenter.new(group).to_json #display group in JSON
  end
end
