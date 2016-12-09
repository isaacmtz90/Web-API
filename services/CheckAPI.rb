# frozen_string_literal: true

# check given group (url) in the WebAPI
class CheckAPI
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_api, lambda { |meetup_group_url|
    if Meetup::Group.find(urlname: meetup_group_url)
      Right(Meetup::Group.find(urlname: meetup_group_url))
    else
      Left(Error.new(:bad_request, "Group (url: #{meetup_group_url}) could not be found")) # halt 400
    end
  }


  def self.call(meetup_group_url)
    Dry.Transaction(container: self) do
      step :check_api
    end.call(meetup_group_url)
  end
end
