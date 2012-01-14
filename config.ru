require 'yaml'
require 'iron_worker'

@config = {}
@config = YAML.load_file('config.yml') if File.exists?('config.yml')

@config["iron"] ||= {}
@config["iron"]["token"] ||= ENV['IRON_WORKER_TOKEN']
@config["iron"]["project_id"] ||= ENV['IRON_WORKER_PROJECT_ID']

IronWorker.configure do |iwc|
  iwc.token = @config["iron"]["token"]
  iwc.project_id = @config["iron"]["project_id"]
end

ironmq =  IronMQ::Client.new('token' => @config["iron"]["token"], 'project_id' => @config["iron"]["project_id"])
#ironmq.logger.level = Logger::DEBUG
set :ironmq, ironmq

require './hello'
run Sinatra::Application
