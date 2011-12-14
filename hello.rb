require 'sinatra'
require_relative 'workers/tweet_worker'
#require_relative ''

enable :sessions
set :public_folder, File.dirname(__FILE__) + '/static'
set :ironmq, IronMQ::Client.new('token'=>ENV['IRON_WORKER_TOKEN'], 'project_id'=>ENV['IRON_WORKER_PROJECT_ID'])
set :queue_name, "tweets"

post '/run_tweet_worker' do
  worker = TweetWorker.new
  worker.token = ENV['IRON_WORKER_TOKEN']
  worker.project_id = ENV['IRON_WORKER_PROJECT_ID']
  puts "settings.queue_name=" + settings.queue_name
  worker.queue_name = settings.queue_name
  # todo: store worker id in session then ajax show progress
  worker.queue

  session[:worker_id] = worker.task_id
  puts 'worker_id in session=' + worker.task_id
  #worker.wait_until_complete
  #p worker.status
  #"status=" + worker.status.inspect
  redirect '/'
end

get '/worker_status' do
  puts 'worker_id in session? ' + session[:worker_id].inspect
  if session[:worker_id]
    status = IronWorker.service.status(session[:worker_id])
    puts "status=" + status.inspect
    ret = {}
    ret['msg'] = "Worker running"
    ret['task_id'] = session[:worker_id]
    ret['status'] = status["status"]
    if status["status"] != "queued" && status["status"] != "running"
      session[:worker_id] = nil
    end
    return ret.to_json
  else
    return {msg: "No worker running."}.to_json
  end
end


get '/' do
  @msg = settings.ironmq.messages.get(:queue_name=>settings.queue_name)
  @msg.delete if @msg
  erb :hello
end

get '*' do
  if request.host == "blog.simpleworker.com"
    redirect "#{request.scheme}://blog.iron.io#{request.path}"
    return true
  end
  redirect '/'
end
