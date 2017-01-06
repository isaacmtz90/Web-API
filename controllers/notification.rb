# frozen_string_literal: true

# Controller for the sms
class EventsLocatorAPI < Sinatra::Base
  post "/#{API_VER}/invite_sms_send/?" do
    result = SendInvitationSMS.call(request.body.read)
    if result.success?
      print result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # post "/#{API_VER}/send_notification/?" do
  #   request = ValidateSMSRequest.call(request.body.read)
  #   if request.failure?
  #     ErrorRepresenter.new(result.value).to_status_response
  #   else
  #     res = CreateNewNotificationWorker.perform_async(request.value)
  #     puts "WORKER: #{res}"
  #     status 202
  #   end
  # end
  # To implement later:!
  post "/#{API_VER}/send_invitation/?" do
    result = QueueInvitationSMS.call(request.body.read)
    if result.success?
      print result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
