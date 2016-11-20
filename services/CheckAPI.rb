# frozen_string_literal: true

# check whether group already exists in database
class CheckAPI
  extend Dry::Monads::Either::Mixin

  def self.call(meetup_group_url)
    if Meetup::Group.find(urlname: meetup_group_url)
      Right(Meetup::Group.find(urlname: meetup_group_url))
    else
      Left(Error.new(400, "Group (url: #{meetup_group_url}) could not be found")) # halt 400
    end

  end
end
