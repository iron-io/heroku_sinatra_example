require 'sinatra'

enable :sessions
set :public_folder, File.dirname(__FILE__) + '/static'

post '/run_tweet_worker' do

  #worker = TweetWorker.new
  #worker.token = IronWorker.config.token
  #worker.project_id = IronWorker.config.project_id
  #puts "settings.queue_name=" + settings.queue_name
  #worker.queue_name = settings.queue_name
  ## todo: store worker id in session then ajax show progress
  #worker.queue

  task = settings.iron_worker.tasks.create("TweetWorker",
                                           { :mq => settings.ironmq.options,
                                             :queue_name => settings.queue_name,
                                             :twitter => settings.twitter_conf })

  session[:worker_id] = task.id
  puts 'worker_id in session=' + task.id
  #worker.wait_until_complete
  #p worker.status
  #"status=" + worker.status.inspect
  redirect '/'
end

get '/worker_status' do
  puts 'worker_id in session? ' + session[:worker_id].inspect
  if session[:worker_id]
    task = settings.iron_worker.tasks.get(session[:worker_id])
    #status = IronWorker.service.status(session[:worker_id])
    puts "status=" + task.inspect
    ret = {}
    ret['msg'] = "Worker running"
    ret['task_id'] = session[:worker_id]
    ret['status'] = task.status
    ret['percent'] = task.percent || 0
    ret['msg'] = task.msg || ""
    if  task.status != "queued" &&  task.status != "running"
      session[:worker_id] = nil
    end
    return ret.to_json
  else
    return {msg: "No worker running."}.to_json
  end
end


get '/' do
  if session[:worker_id]
    @running = true
  end
  @msg = settings.ironmq.queue(settings.queue_name).get
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
