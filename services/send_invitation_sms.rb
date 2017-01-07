# frozen_string_literal: true
require 'every8d'
# save group into database
class SendInvitationSMS
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  PHONE_REGEX = /\d{9,10}/
  register :validate_request_json, lambda { |request_body|
    begin
      notification_body = SMSSendRequestRepresenter.new(SMSRequest.new)
      Right(notification_body.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, ' SMS request could not be resolved'))
    end
  }
  register :check_input, lambda { |params|
    begin
      # puts params [:to]
      # to = params[:to]
      message = params[:message]
      # url = params[:url]
      destination_number = params[:to][PHONE_REGEX]
      print destination_number
      if [destination_number, message].all?
        Right(to: destination_number, message: message)
      else
        # puts xep
        Left(Error.new(:cannot_process, 'Missing params sending sms, check input'))
      end
    rescue => e
      puts e
      Left(Error.new(:cannot_process, 'Error on SMS sending, check input'))
    end
  }

  register :send_sms, lambda { |params|
    begin
      # print params
      message = params[:message]
      account_sid = EventsLocatorAPI.config.EVERY8D_ACCOUNT
      account_pwd = EventsLocatorAPI.config.EVERY8D_PW
      @client = Every8d::Client.new(UID: account_sid, PWD: account_pwd)
      response = @client.send_sms(
        MSG: message.to_s,
        DEST: params[:to].to_s
      )
      puts response
      Right(params)
    rescue =>eexc
      puts eexc
      Left(Error.new(:internal_error, 'Cannot send sms from sender'))
    end
  }

  def self.call(meetup_group)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :check_input
      step :send_sms
    end.call(meetup_group)
  end
end
