# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchByText
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.query_all(text)
    events = Event.association_inner_join(:city).where(
      Sequel.join([:event_name, :description, :venue]).ilike("%#{text}%")
    ).select_all(:events)
    events
  end

  def self.query_city(city, text)
    events = Event.association_inner_join(:city).where(city_id: city.to_i).where(
      Sequel.join([:event_name, :description, :venue]).ilike("%#{text}%")
    ).select_all(:events)
    events
  end

  register :validate_text, lambda { |params|
    queryterm = params[:term]
    city = params[:city]
    if queryterm != ''
      Right(query: queryterm, city: city)
    else
      Left(Error.new(:cannot_process, 'Search input is empty'))
    end
  }

  register :search_events, lambda { |params|
    text = params[:query]
    city = params[:city]
    if city.to_i.zero?
      events = query_all(text)
    else
      events = query_city(city, text)
    end
    if events.count.positive?
      Right(Events.new(events))
    else
      Left(Error.new(:not_found, 'Search input is empty'))
    end
  }


  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_text
      step :search_events
    end.call(params)
  end
end
