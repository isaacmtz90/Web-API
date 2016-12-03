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
  HAPPY_CITY_TEXT = 'Taipei'

  # Real and fake groups urls
  HAPPY_GROUP_URL = 'Hiking-and-Riding-in-Taipei'
  SAD_GROUP_URL = 'xxxzzzzfff'

  # Fake country code and non-related location text
  SAD_COUNTRY_CODE = 'WT' # should be "SG"
  SAD_CITY_TEXT = 'Asljn'

  before do
    VCR.insert_cassette MEETUP_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end
  describe 'Loading and Saving  Events in the DB by city' do
    before do
      delete_db_data()
    end
    it '(HAPPY) should create and save a city plus events' do
      post 'api/v0.1/city/',
           { 'city': HAPPY_CITY_TEXT,
             'country_code': HAPPY_COUNTRY_CODE }.to_json,
           'CONTENT_TYPE' => 'application/json'
      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'name'
      body.must_include 'country_code'
      City.count.must_equal 1
      Event.count.must_be :>=, 5
    end
    it '(SAD) should not create and save a city for unknown ones' do
      post 'api/v0.1/city/',
           { 'city': SAD_CITY_TEXT,
             'country_code': SAD_COUNTRY_CODE }.to_json,
           'CONTENT_TYPE' => 'application/json'
      last_response.status.must_be :!=, 200
    end
  end

  describe 'Find Meetup Events by Location' do
    before do
      delete_db_data()
      post 'api/v0.1/city/',
           { 'city': HAPPY_CITY_TEXT,
             'country_code': HAPPY_COUNTRY_CODE }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end
    it 'HAPPY: should find cities' do
      get URI.encode('api/v0.1/cities')
      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      # print body
      body.length.must_be :>=, 1
    end

    it 'HAPPY: should find events given a location' do
      get URI.encode('api/v0.1/cities')
      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      city_id = body['cities'][0]['id']
      get URI.encode("api/v0.1/city/#{city_id}/events/")
      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body['events'].length.must_be :>=, 1
      last_response.content_type.must_equal 'application/json'
    end

    it 'SAD: should report if events from a city are not found' do
      get URI.encode('api/v0.1/city/9999999/events')
      last_response.status.must_equal 404
    end
  end
end
