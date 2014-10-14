# RedisNotifier

Observe redis keyevent/keyspace and notify

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis_notifier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_notifier

## Usage

```ruby
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
``

## Contributing

1. Fork it ( https://github.com/[my-github-username]/redis_notifier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
