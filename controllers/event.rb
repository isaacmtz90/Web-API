# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'meetupevents'
require_relative './config/environment.rb'

class EventsLocatorAPI < Sinatra::Base
  include WordMagic

  # route to find groups based on coutry code and location text
  get "/#{API_VER}/groups/meetup/:countrycode/:locationtextquery/?" do
    countrycode = params[:countrycode]
    locationtext = params[:locationtextquery]
    begin
      response = Meetup::MeetupApi.get_groups(countrycode, locationtext)

      # Check if first result matches provided country code, 404 if not
      parsed_response = JSON.parse(response.to_json)
      if parsed_response.first['country'] != countrycode.upcase
        raise "country code does not match to query"
      end

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Groups in country #{countrycode} at location #{locationtext} not found!"
    end
  end

  # route to find events based on location defined by latitude[-90<>90] & longitude[-180<>180]
  get "/#{API_VER}/events/meetup/:lat&:lon" do
    latitude = params[:lat]
    longitude = params[:lon]
    begin
      response = Meetup::MeetupApi.get_events(latitude, longitude)

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Events at location (lan:#{latitude} , lon:#{longitude}) not found!"
    end
  end

  post "/#{API_VER}/events/?" do
    begin
      #
    rescue
      #
    end
  end

  # Give user the possibility of creating and add a new event manually??
  put "/#{API_VER}/events/:name&:countrycode&:city/?" do
    event_name = params[:name]
    country = params[:countrycode]
    city = params[:city]
    begin
      #
    rescue
      #
    end
  end
end
