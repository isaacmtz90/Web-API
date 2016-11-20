class EventRepresenter
  def initialize(event)
    @event = event
  end

  def to_json
    @event.to_json
  end
end
