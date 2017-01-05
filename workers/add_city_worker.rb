# frozen_string_literal: true
require 'econfig'
require 'shoryuken'

# folders = 'lib,values,config,models,representers,services'
# Dir.glob("../{#{folders}}/init.rb").each do |file|
#   require file
# end

# require_relative '../lib/init.rb'
require_relative '../values/init.rb'
require_relative '../config/init.rb'
require_relative '../models/init.rb'
require_relative '../representers/init.rb'
require_relative '../services/init.rb'

# Worker
class AddCityWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  ENV['AWS_REGION'] = config.AWS_REGION
  ENV['AWS_ACCESS_KEY_ID'] = config.AWS_ACCESS_KEY_ID
  ENV['AWS_SECRET_ACCESS_KEY'] = config.AWS_SECRET_ACCESS_KEY
  ENV['MEETUP_API_KEY'] = config.MEETUP_API_KEY

  include Shoryuken::Worker
  shoryuken_options queue: config.NEW_CITY_QUEUE, auto_delete: true

  def perform(_sqs_msg, params)
    puts "REQUEST: adding city"
    result = LoadCityFromMeetup.call(params)
    puts "RESULT: #{result.value}"

    HttpResultRepresenter.new(result.value).to_status_response
  end
end
