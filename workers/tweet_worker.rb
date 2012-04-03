
class TweetWorker < IronWorker::Base

  merge_gem 'iron_mq'
  merge_gem 'twitter'

  attr_accessor :token, :project_id, :queue_name

  def run
    puts "Hello! I am Uber."

    set_progress(:msg=>"Getting tweet...", :percent=>10)

    tweet = Twitter.search("#cloud -rt").first.text
    puts "tweet=#{tweet}"

    set_progress(:msg=>"Got tweet...", :percent=>60)

    ironmq = IronMQ::Client.new('token'=>token, 'project_id'=>project_id)
    response = ironmq.messages.post(tweet, :queue_name=>queue_name)

    puts "tweet put on queue. " + response.inspect

  end
end
