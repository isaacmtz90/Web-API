# frozen_string_literal: true

# check given group (url) in the WebAPI
class CheckAll
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :check_database, lambda { |meetup_group_url|
    if Group.find(urlname: meetup_group_url)
      Left(Error.new(:cannot_process, "Group #{meetup_group_url} already exists")) # halt 422
    else
      #Right(Group.find(urlname: meetup_group_url)) # do nothing!
      Right(meetup_group_url)
    end
  }

  register :check_api, lambda { |meetup_group_url|
    if Meetup::Group.find(urlname: meetup_group_url)
      Right(Meetup::Group.find(urlname: meetup_group_url))
    else
      Left(Error.new(:bad_request, "Group (url: #{meetup_group_url}) could not be found")) # halt 400
    end
  }

  register :save_group_to_database, lambda { |meetup_group|
    group = Group.create(group_name: meetup_group.name,
                         urlname: meetup_group.urlname,
                         city: meetup_group.city,
                         country_code: meetup_group.country)
    if group
      Right(group)
    else
      Left(Error.new(:internal_error, "Cannot create group"))
    end
  }


  def self.call(meetup_group_url)
    Dry.Transaction(container: self) do
      step :check_database
      step :check_api
      step :save_group_to_database
    end.call(meetup_group_url)
  end
end
