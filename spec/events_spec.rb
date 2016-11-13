# frozen_string_literal: true
require_relative 'spec_helper'

require 'rake/testtask'
describe 'Meetup Events Routes' do
  # Taipei City Real LAT & LON
  HAPPY_LAT = 25
  HAPPY_LON = 121

  # Taipei City Fake LAT & LON
  SAD_LAT = 1000
  SAD_LON = 1000

  # Real code country and location text query
  HAPPY_COUNTRY_CODE = 'TW'
  HAPPY_LOCATION_TEXT = '\"Taipei\"'

  # Real and fake groups urls
  HAPPY_GROUP_URL = 'Hiking-and-Riding-in-Taipei'
  SAD_GROUP_URL = 'xxxzzzzfff'

  # Fake country code and non-related location text
  SAD_COUNTRY_CODE = 'WT' # should be "SG"
  SAD_LOCATION_TEXT = '\"Singapore\"'

  before do
    VCR.insert_cassette MEETUP_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end
  describe 'Loading and Saving  Group in the DB by urlname' do
    before do
      DB[:groups].delete
      DB[:events].delete
    end
    it '(HAPPY) should load and save a new group by its Meetup URL' do
      post 'api/v0.1/group/',
           { url: HAPPY_GROUP_URL }.to_json,
           'CONTENT_TYPE' => 'application/json'
      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'name'
      body.must_include 'city'
      Group.count.must_equal 1
    end
  end

  describe 'Find Meetup Events by Location' do
    it 'HAPPY: should find an event given a location' do
      get URI.encode("api/v0.1/events/#{HAPPY_LAT}&#{HAPPY_LON}")

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
    end

    it 'SAD: should report if location does not exist' do
      get URI.encode("api/v0.1/meetup/events/#{SAD_LAT}&#{SAD_LON}")

      last_response.status.must_equal 404
    end
  end

  describe 'Find Meetup Groups by Location Text Query' do
    it 'HAPPY: should find a group given a location' do
      get URI.encode("api/v0.1/groups/#{HAPPY_COUNTRY_CODE}/#{HAPPY_LOCATION_TEXT}")

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      events_data = JSON.parse(last_response.body)
      events_data.first['country'].must_equal HAPPY_COUNTRY_CODE
    end

    it 'SAD: should report if provided wrong country code or location text' do
      get URI.encode("api/v0.1/groups/#{SAD_COUNTRY_CODE}/#{SAD_LOCATION_TEXT}")

      last_response.status.must_equal 404
    end
  end
end
