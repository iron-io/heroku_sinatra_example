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
@config["iron_worker"] ||= {}
@config["iron_worker"]["token"] ||= ENV['IRON_WORKER_TOKEN']
@config["iron_worker"]["project_id"] ||= ENV['IRON_WORKER_PROJECT_ID']
@config["iron_mq"] ||= {}
@config["iron_mq"]["token"] ||= ENV['IRON_MQ_TOKEN']
@config["iron_mq"]["project_id"] ||= ENV['IRON_MQ_PROJECT_ID']
p @config

set :iron_worker, IronWorkerNG::Client.new(:token=>@config["iron_worker"]["token"], :project_id=>@config["iron_worker"]["project_id"])

set :queue_name, "tweets"
ironmq = IronMQ::Client.new(:token => @config["iron_mq"]["token"], :project_id => @config["iron_mq"]["project_id"])
#ironmq.logger.level = Logger::DEBUG
set :ironmq, ironmq

require './hello'
run Sinatra::Application
