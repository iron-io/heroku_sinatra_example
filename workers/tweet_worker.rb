require 'twitter'
require 'iron_mq'

puts "Running..."
p params

tweet = Twitter.search("#cloud -rt").first.text
puts "tweet=#{tweet}"

ironmq = IronMQ::Client.new('token' => params['token'], 'project_id' => params['project_id'])
response = ironmq.messages.post(tweet, :queue_name => queue_name)

puts "tweet put on queue. " + response.inspect
