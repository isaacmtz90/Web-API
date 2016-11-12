# frozen_string_literal: true

# configure based on environment
class EventsLocatorAPI < Sinatra::Base
  extend Econfig::Shortcut

  API_VER = 'api/v0.1'

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)
    Meetup::MeetupApi.config.update(access_key: config.MEETUP_API_KEY)

    # this is not working! will get 'invalid api key' error in the WebAPI routes responses...
    # the code bellow somehow doesn't define MEETUP_API_KEY environment variable for our meetupevents gem to use
    Meetup::MeetupApi
      .config
      .update(access_key: EventsLocatorAPI.config.MEETUP_API_KEY)

    # this is the fix for problem stated above
    # manually define MEETUP_API_KEY environment variable from credentials stored at config/app.yml
    ENV['MEETUP_API_KEY'] = EventsLocatorAPI.config.MEETUP_API_KEY
  end

  # root route to test if Web API is up
  get '/?' do
    "EventsLocatorAPI latest version endpoints are at: /#{API_VER}/!"
  end
end
