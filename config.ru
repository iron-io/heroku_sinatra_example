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

@config["iron_worker"] ||= @config["iron"] || {}
iw_conf_heroku = {
  'token' => ENV['IRON_WORKER_TOKEN'] || ENV['IRON_IO_TOKEN'],
  'project_id' => ENV['IRON_WORKER_PROJECT_ID'] || ENV['IRON_IO_PROJECT_ID']
}
@config["iron_worker"].merge!(iw_conf_heroku) do |k, v1, v2|
  (v2.nil? || v2.empty?) ? v1 : v2
end

@config["iron_mq"] ||= @config["iron"] || {}
imq_conf_heroku = {
  'token' => ENV['IRON_MQ_TOKEN'] || ENV['IRON_IO_TOKEN'],
  'project_id' => ENV['IRON_MQ_PROJECT_ID'] || ENV['IRON_IO_PROJECT_ID']
}
@config["iron_mq"].merge!(imq_conf_heroku) do |k, v1, v2|
  (v2.nil? || v2.empty?) ? v1 : v2
end

p @config

set :iron_worker, IronWorkerNG::Client.new(@config["iron_worker"])

set :queue_name, "tweets"
ironmq = IronMQ::Client.new(@config["iron_mq"])
#ironmq.logger.level = Logger::DEBUG
set :ironmq, ironmq

set :twitter_conf, @config['twitter']

require './hello'
run Sinatra::Application
