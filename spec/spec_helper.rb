ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require './init.rb'

include Rack::Test::Methods

def app
  EventsLocatorAPI
end

FIXTURES_FOLDER = 'spec/fixtures'
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes"
MEETUP_CASSETTE = 'Meetup'
def delete_db_data
  DB[:cities].delete
  DB[:events].delete
end
VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock
  c.ignore_hosts 'sqs.us-east-1.amazonaws.com'
  c.ignore_hosts 'sqs.ap-northeast-1.amazonaws.com'

  c.filter_sensitive_data('<MEETUP_API_KEY>') do
    URI.unescape(app.config.MEETUP_API_KEY)
  end

  c.filter_sensitive_data('<AMEETUP_API_KEY_ESCAPED>') do
    app.config.MEETUP_API_KEY
  end

  c.filter_sensitive_data('<MEETUP_API_KEY>') { ENV['MEETUP_API_KEY'] }
end

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
