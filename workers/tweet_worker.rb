require 'twitter'
require 'iron_mq'

puts "Running..."
p params

twitter = Twitter::Client.new(params['twitter'])
tweet = twitter.search("#cloud -rt").results.first.text
puts "tweet=#{tweet}"

ironmq = IronMQ::Client.new(params['mq'])
response = ironmq.queue(params['queue_name']).post(tweet)

puts "tweet put on queue. " + response.inspect
