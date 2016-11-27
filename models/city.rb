# frozen_string_literal: true

# Represents a Event's stored information
class City < Sequel::Model
  one_to_many :events
end
