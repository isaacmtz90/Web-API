# frozen_string_literal: true
require 'google_url_shortener'
# save group into database
class ShortenUrl
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin


  register :shorten_url, lambda { |long_url|
    print long_url
    begin
      Google::UrlShortener::Base.log = $stdout
      Google::UrlShortener::Base.api_key = EventsLocatorAPI.config.GOOGLE_API_KEY
      url = Google::UrlShortener::Url.new(long_url: long_url)
      short_url = url.shorten!
      puts url
      puts short_url
      Right(short_url)
    rescue => error
      puts error
      Left(Error.new(:bad_request, "URL couldnt be shortened #{error}"))
    end
  }


  def self.call(meetup_group)
    Dry.Transaction(container: self) do
      step :shorten_url
    end.call(meetup_group)
  end
end
