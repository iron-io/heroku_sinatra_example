require 'twitter'
require 'iron_mq'

puts "Running..."
p params

tweet = Twitter.search("#cloud -rt").results.first.text
puts "tweet=#{tweet}"

mq_params = params['mq']
ironmq = IronMQ::Client.new('token' => mq_params['token'], 'project_id' => mq_params['project_id'])
response = ironmq.messages.post(tweet, :queue_name => mq_params['queue_name'])

puts "tweet put on queue. " + response.inspect
