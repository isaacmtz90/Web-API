# frozen_string_literal: true

# check whether group already exists in database
class CheckDatabase
  extend Dry::Monads::Either::Mixin

  def self.call(meetup_group_url)
    if Group.find(urlname: meetup_group_url)
      Left(Error.new(:cannot_process, "Group #{meetup_group_url} already exists")) # halt 422
    else
      Right(Group.find(urlname: meetup_group_url)) # do nothing!
    end
  end
end
