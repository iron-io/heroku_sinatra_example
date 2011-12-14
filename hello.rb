require 'sinatra'
require_relative 'workers/uber_worker'
#require_relative ''

set :public_folder, File.dirname(__FILE__) + '/static'
set :ironmq, IronMQ::Client.new('token'=>ENV['IRON_WORKER_TOKEN'], 'project_id'=>ENV['IRON_WORKER_PROJECT_ID'])
set :queue_name, "tweets"

post '/run_uber_worker' do
  worker = UberWorker.new
  worker.token = ENV['IRON_WORKER_TOKEN']
  worker.project_id = ENV['IRON_WORKER_PROJECT_ID']
  puts "settings.queue_name=" + settings.queue_name
  worker.queue_name = settings.queue_name
  # todo: store worker id in session then ajax show progress
  worker.queue
  worker.wait_until_complete
  p worker.status
  "status=" + worker.status.inspect
end

get '/' do
  @msg = settings.ironmq.messages.get(:queue_name=>settings.queue_name)
  erb :hello
end

get '*' do
  if request.host == "blog.simpleworker.com"
    redirect "#{request.scheme}://blog.iron.io#{request.path}"
    return true
  end
  redirect '/'
end
