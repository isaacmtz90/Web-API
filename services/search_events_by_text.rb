# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchByText
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_text, lambda { |params|
    queryterm = params[:term]
    if queryterm != ''
      Right(queryterm)
    else
      Left(Error.new(:cannot_process, 'Search input is empty'))
    end
  }

  register :search_events, lambda { |text|
    events = Event.where(
      Sequel.join([:event_name, :description, :venue]).ilike("%#{text}%")
    ).all
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
