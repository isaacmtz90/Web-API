# frozen_string_literal: true

# save group into database
class ValidateSMSRequest
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  PHONE_REGEX = /\D(\d{5})\D/
  register :validate_request_json, lambda { |request_body|
    begin
      notification_body = NotificationRequestRepresenter.new(NotificationRequest.new)
      Right(notification_body.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, ' SMS request could not be resolved'))
    end
  }
  register :check_input, lambda { |params|
    to = params['to']
    message = params['message']
    destination_number = to.match(PHONE_REGEX)&.[](1)
    if [destination_number, message].all?
      Right(to: destination_number, message: message)
    else
      Left(Error.new(:cannot_process, 'Error on SMS sending, check input'))
    end
  }
  def self.call(meetup_group)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :check_input
    end.call(meetup_group)
  end
end
