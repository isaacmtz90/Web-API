# frozen_string_literal: true

# check whether group already exists in database
class CheckDatabase
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_database, lambda { |meetup_group_url|
    if Group.find(urlname: meetup_group_url)
      Left(Error.new(:cannot_process, "Group #{meetup_group_url} already exists")) # halt 422
    else
      Right(Group.find(urlname: meetup_group_url)) # do nothing!
    end
  }

  def self.call(meetup_group_url)
    Dry.Transaction(container: self) do
      step :check_database
    end.call(meetup_group_url)
  end
end
