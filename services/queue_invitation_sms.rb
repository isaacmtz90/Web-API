# frozen_string_literal: true
# require 'every8d'
# save group into database
class QueueInvitationSMS
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
    from = params['from']
    event_name = params['event_name']
    event_id = params['event_id']
    print to, from, event_name, event_id
    if [to, from, event_name, event_id].all?
      Right(to: to, from: from, event_name: event_name, event_id: event_id)
    else
      Left(Error.new(:cannot_process, 'Error on SMS queuing, check input'))
    end
  }

  # register :sendSMS, lambda { |params|
  #   begin
  #     # print params
  #     message = params[1]
  #     account_sid = EventsLocatorAPI.config.EVERY8D_ACCOUNT
  #     account_pwd = EventsLocatorAPI.config.EVERY8D_PW
  #     @client = Every8d::Client.new(UID: account_sid, PWD: account_pwd)
  #     @client.send_sms(
  #       MSG: message.to_s,
  #       DEST: params[0].to_s
  #     )
  #     Right(params)
  #   rescue
  #     Left(Error.new(:internal_error, 'Cannot send sms'))
  #   end
  # }
  register :sendToQueue, lambda { |params|
    begin
      puts 'Sending to sms queue'
      config = EventsLocatorAPI.config
      sqs = Aws::SQS::Client.new(access_key_id: config.AWS_ACCESS_KEY_ID,
                                 secret_access_key: config.AWS_SECRET_ACCESS_KEY,
                                 region: config.AWS_REGION)
      q_url = sqs.get_queue_url(queue_name: config.SMS_NOTI_QUEUE).queue_url
      api_url = "#{config.API_URL}/#{config.API_VER}"
      msg = {
        url: "#{api_url}/invite_sms_send/",
        from: params[:from],
        to: params[:to],
        evt_name: params[:event_name],
        evt_url: "https://goo.gl/FD61SA"
      }.to_json
      puts msg
      res = sqs.send_message(queue_url: q_url, message_body: msg)
      puts res.inspect
      Right(params)
    rescue => e
      puts e
      Left(Error.new(:internal_error, 'Cannot send sms'))
    end
  }

  register :storeNotificationDB, lambda { |params|
    begin
      noti = Notification.create(to: params[:to],
                                 from: params[:from],
                                 event_name: params[:event_name],
                                 event_id: params[:event_id].to_i)
      Right(HttpResult.new(:success, "Invitation Queued"))
    rescue => e
      puts e
      Left(Error.new(:internal_error, "Cannot store sms inv #{e}"))
    end
  }

  def self.call(notification)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :check_input
      step :sendToQueue
      step :storeNotificationDB
    end.call(notification)
  end
end
