$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'redis'
require 'redis_notifier'

redis_notifier = RedisNotifier::Base.new(Redis.new)

redis_notifier.on_event(:expired) do |key|
  puts "** #{key} as expired"
end

redis_notifier.observe_key('keys:my_key') do |event|
  puts ">> event '#{event}' on 'keys:my_key"
end

redis_notifier.listen
