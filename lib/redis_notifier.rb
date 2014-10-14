require "redis_notifier/version"
require 'logger'

module RedisNotifier

  NoBlockGiven = Class.new(StandardError)

  class NullLogger
    def debug(msg); end
    def warn(msg); end
    def info(msg); end
    def error(msg); end
  end

  class Base

    NOTIFY_KEYSPACE_EVENTS = 'notify-keyspace-events'

    attr_reader :redis, :db, :callbacks, :listened_channels, :logger

    def initialize(redis, db=0, keyspace_config='KEA', logger=NullLogger.new)
      @logger = logger
      @db = db.to_s
      @redis = redis
      redis.config(:set, NOTIFY_KEYSPACE_EVENTS, keyspace_config)
      @callbacks = { keys: {}, events: {} }
      @listened_channels = []
    end

    def on_event(event_name, &block)
      on :events, event_name, &block
    end

    def observe_key(key, &block)
      on :keys, key, &block
    end

    def on(type, prefix, &block)
      raise NoBlockGiven unless block_given?
      channel = build_channel_for(type, prefix)
      return if @listened_channels.include?(channel)
      @listened_channels << channel
      @callbacks[type][prefix.to_s] = block
    end

    def build_channel_for(type, prefix)
      case type
      when :events
        "__keyevent@#{db}__:#{prefix}"
      when :keys
        "__keyspace@#{db}__:#{prefix}"
      end
    end

    def find_type_from(channel)
      if channel.include?('__keyevent@')
        :events
      elsif channel.include?('__keyspace@')
        :keys
      else
        nil
      end
    end

    def listen
      logger.debug("listened channels: #{listened_channels}")
      redis.subscribe(listened_channels) do |on|
        on.message do |ch, msg|
          logger.debug("message received: channel=#{ch}; msg=#{msg}")

          extracted_key = ch.split(':')[1..-1].join(':')

          logger.debug("extracted key: #{extracted_key}")

          if type = find_type_from(ch)
            callbacks[type][extracted_key].call(msg)
          else
            logger.warn("message received but not in keyspace or keyevent")
          end

        end
      end
    end

  end

end
