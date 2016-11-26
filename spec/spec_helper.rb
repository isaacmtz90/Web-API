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

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<MEETUP_API_KEY>') do
    URI.unescape(app.config.MEETUP_API_KEY)
  end

  c.filter_sensitive_data('<AMEETUP_API_KEY_ESCAPED>') do
    app.config.MEETUP_API_KEY
  end

  c.filter_sensitive_data('<MEETUP_API_KEY>') { ENV['MEETUP_API_KEY'] }
end
