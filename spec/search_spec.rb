# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Search Routes' do
  before do
    VCR.insert_cassette MEETUP_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end
  describe 'Find Meetup Events by Text' do
    before do
      delete_db_data()
      post 'api/v0.1/city/',
           { 'city': HAPPY_CITY_TEXT,
             'country_code': HAPPY_COUNTRY_CODE }.to_json,
           'CONTENT_TYPE' => 'application/json'
    end
    it 'HAPPY: should find cities for search event' do
      get URI.encode('api/v0.1/cities')
      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      # print body
      body.length.must_be :>=, 1
    end

    it 'HAPPY: should find events given a search term' do
      search_term = 'python'
      get URI.encode("api/v0.1/events/search/#{search_term}")
      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body['events'].length.must_be :>=, 1
      last_response.content_type.must_equal 'application/json'
    end

    it 'SAD: should report if no event resuts  are not found' do
      search_term = 'ASJL2352JLLJDLJ332'
      get URI.encode("api/v0.1/events/search/#{search_term}")
      last_response.status.must_equal 404
    end
  end
end
