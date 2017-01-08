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

  register :send_to_queue, lambda { |params|
    begin
      puts 'Sending to sms queue'
      config = EventsLocatorAPI.config
      sqs = Aws::SQS::Client.new(access_key_id: config.AWS_ACCESS_KEY_ID,
                                 secret_access_key: config.AWS_SECRET_ACCESS_KEY,
                                 region: config.AWS_REGION)
      q_url = sqs.get_queue_url(queue_name: config.SMS_NOTI_QUEUE).queue_url
      api_url = "#{config.API_URL}/#{config.API_VER}"
      app_url = config.APP_URL
      event_id = params[:event_id]
      # shorten the url with google_url_shortener
      shorten_url = ShortenUrl.call("#{app_url}/event/#{event_id}")
      if shorten_url.success?
        short_url = shorten_url.value
      else
        short_url = 'https://goo.gl/FD61SA' #homepage url
      end
      msg = {
        url: "#{api_url}/invite_sms_send/",
        from: params[:from],
        to: params[:to],
        evt_name: params[:event_name],
        evt_url: short_url
      }.to_json
      res = sqs.send_message(queue_url: q_url, message_body: msg)
      Right(params)
    rescue => e
      puts e
      Left(Error.new(:internal_error, 'Cannot send sms'))
    end
  }

  register :store_invitation_db, lambda { |params|
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
      step :send_to_queue
      step :store_invitation_db
    end.call(notification)
  end
end
