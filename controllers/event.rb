# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'meetupevents'
require_relative '../config/environment.rb'

# Controller for the events
class EventsLocatorAPI < Sinatra::Base
  # route to find events based on location defined by
  # latitude[-90<>90] & longitude[-180<>180]
  get "/#{API_VER}/events/:lat&:lon" do
    latitude = params[:lat]
    longitude = params[:lon]
    begin
      response = Meetup::MeetupApi.get_events(latitude, longitude)
      
      content_type 'application/json'
      #response.to_json
      EventsLocatorAPI.new(response).to_json

    rescue
      halt 404, "Events at location (lan:#{latitude} , lon:#{longitude}) not found!"
    end
  end

  # another route yet to be defined
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
