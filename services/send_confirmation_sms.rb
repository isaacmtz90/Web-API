# frozen_string_literal: true
require 'every8d'
# save group into database
class SendConfirmationSMS
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_request_json, lambda { |request_body|
    begin
      notification_body = NotificationRequestRepresenter.new(NotificationRequest.new)
      Right(notification_body.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, 'Request could not be resolved'))
    end
  }
  register :check_input, lambda { |params|
    to = params['to']
    message = params['message']
    print to, message
    if [to, message].all?
      Right([to, message])
    else
      Left(Error.new(:cannot_process, 'Error on SMS sending, check input'))
    end
  }

  register :sendSMS, lambda { |params|
    begin
      print params
      message = params[1]
      account_sid = EventsLocatorAPI.config.EVERY8D_ACCOUNT
      account_pwd = EventsLocatorAPI.config.EVERY8D_PW
      @client = Every8d::Client.new(UID: account_sid, PWD: account_pwd)
      @client.send_sms(
        MSG: message.to_s,
        DEST: params[0].to_s
      )
      Right('sms sent')
    rescue
      Left(Error.new(:internal_error, 'Cannot send sms'))
    end
  }

  def self.call(meetup_group)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :check_input
      step :sendSMS
    end.call(meetup_group)
  end
end
