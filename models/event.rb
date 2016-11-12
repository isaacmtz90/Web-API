# frozen_string_literal: true

# Represents a Event's stored information
class Event < Sequel::Model
  # many_to_one :group # only one database table, no need for cardinality, right?
end
