require 'yaml'
require 'iron_worker'

#@config = YAML.load_file('config.yml')

IronWorker.configure do |iwc|
  iwc.token = ENV['IRON_WORKER_TOKEN']
  iwc.project_id = ENV['IRON_WORKER_PROJECT_ID']
  #iwc.token = @config['iron']['token']
  #iwc.project_id = @config['iron']['project_id']
end

require './hello'
run Sinatra::Application
