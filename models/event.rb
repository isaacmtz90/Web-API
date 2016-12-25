# frozen_string_literal: true

# Represents a Event's stored information
class Event < Sequel::Model
  many_to_one :group
  many_to_one :city
  one_to_many :notification
end
