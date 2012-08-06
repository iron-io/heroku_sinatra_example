require 'yaml'
require 'iron_worker_ng'
require 'iron_mq'
require 'sinatra'
require 'uber_config'

@config = nil
begin
  @config = UberConfig.load
  p @config
rescue => ex
  puts "Swallowed error: #{ex.message}"
end
@config = {} unless @config
@config["iron"] ||= {}
@config["iron"]["token"] ||= ENV['IRON_WORKER_TOKEN']
@config["iron"]["project_id"] ||= ENV['IRON_WORKER_PROJECT_ID']

p @config

IronWorker.configure do |iwc|
  iwc.token = @config["iron"]["token"]
  iwc.project_id = @config["iron"]["project_id"]
end

ironmq = IronMQ::Client.new('token' => @config["iron"]["token"], 'project_id' => @config["iron"]["project_id"])
#ironmq.logger.level = Logger::DEBUG
set :ironmq, ironmq

require './hello'
run Sinatra::Application
