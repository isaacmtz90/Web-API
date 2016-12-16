require_relative 'spec_helper'

describe 'City' do
  before do
    VCR.insert_cassette MEETUP_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Loading and Saving  Events in the DB by city' do
    before do
      delete_db_data
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
end
