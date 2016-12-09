# frozen_string_literal: true

# save group into database
class SaveGroupToDatabase
  extend Dry::Monads::Either::Mixin

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

  def self.call(meetup_group)
    Dry.Transaction(container: self) do
      step :check_response
    end.call(meetup_group)
  end

  #def self.call(meetup_group)
  #  group = Group.create(group_name: meetup_group.name,
  #                       urlname: meetup_group.urlname,
  #                       city: meetup_group.city,
  #                       country_code: meetup_group.country)
  #  if group
  #    Right(group)
  #  else
  #    Left(Error.new(:internal_error, "Cannot create group"))
  #  end
  #end
end
