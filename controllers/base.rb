# frozen_string_literal: true

# configure based on environment
class EventsLocatorAPI < Sinatra::Base
  extend Econfig::Shortcut

  Shoryuken.configure_server do |config|
    config.aws = {
      access_key_id:      config.AWS_ACCESS_KEY_ID,
      secret_access_key:  config.AWS_SECRET_ACCESS_KEY,
      region:             config.AWS_REGION
    }
  end

  API_VER = 'api/v0.1'

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    Meetup::MeetupApi.config.update(access_key: config.MEETUP_API_KEY)

    # manually define MEETUP_API_KEY environment variable from credentials stored at config/app.yml
    ENV['MEETUP_API_KEY'] = EventsLocatorAPI.config.MEETUP_API_KEY
  end

  # root route to test if Web API is up
  get '/?' do
    "EventsLocatorAPI latest version endpoints are at: /#{API_VER}/!"
  end
end
