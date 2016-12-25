# frozen_string_literal: true

# Controller for the sms
class EventsLocatorAPI < Sinatra::Base
  post "/#{API_VER}/notification/?" do
    result = SendConfirmationSMS.call(request.body.read)
    if result.success?
      print result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
