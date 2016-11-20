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
    begin
      response = Meetup::MeetupApi.get_groups(countrycode, locationtext)

      # Check if first result matches provided country code, 404 if not
      parsed_response = JSON.parse(response.to_json)
      if parsed_response.first['country'] != countrycode.upcase
        raise 'country code does not match to query'
      end

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Groups at#{countrycode} at#{locationtext} not found!"
    end
  end
  # Body args (JSON) e.g.: {"url": "http://meetup.com/urlname"}
  post "/#{API_VER}/group/" do
    begin
      body_params = JSON.parse request.body.read
      meetup_group_url = body_params['url']
      if Group.find(urlname: meetup_group_url)
        halt 422, "Group #{meetup_group_url} already exists"
      end
      meetup_group = Meetup::Group.find(urlname: meetup_group_url)

    rescue
      content_type 'text/plain'
      halt 400, "Group (url: #{meetup_group_url}) could not be found"
    end
    begin
      group = SaveGroupToDatabase(meetup_group)

      content_type 'application/json'
      GroupRepresenter.new(group).to_json
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create group (id: #{meetup_group_url})"
    end
  end
end
