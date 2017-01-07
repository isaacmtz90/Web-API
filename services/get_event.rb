# frozen_string_literal: true

# Loads data from Facebook group to database
class GetEvent
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :find_event, lambda { |params|
    puts params
    evt = Event.find(id: params[:id])
    if evt
      Right(evt)
    else
      Left(Error.new(:not_found, 'event not found'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :find_event
    end.call(params)
  end
end
