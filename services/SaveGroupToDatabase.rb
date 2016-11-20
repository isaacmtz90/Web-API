# frozen_string_literal: true

# save group into database
class SaveGroupToDatabase
  extend Dry::Monads::Either::Mixin

  def self.call(meetup_group)
    Group.create(group_name: meetup_group.name,
                         urlname: meetup_group.urlname,
                         city: meetup_group.city,
                         country_code: meetup_group.country)
  end
end