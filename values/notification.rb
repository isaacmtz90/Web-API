# frozen_string_literal: true

NotificationRequest = Struct.new :to, :from, :url, :event_name, :event_id
