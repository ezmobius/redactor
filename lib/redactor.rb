require 'rubygems'
require 'redis'
require 'json'
require 'redactor/actor'


module RedActor
  class << self
    attr_accessor :queues, :redis
    
    def get_queues(timeout=15)
      RedActor.queues.keys << timeout
    end
    
    def run(opts={})
      opts[:timeout] ||= 15
      redis = Redis.new(opts)
      RedActor.redis = redis
      loop do
        queue, msg = redis.blpop(*get_queues(opts[:timeout]))
        if queue && msg
          RedActor.queues[queue].new(redis).__send__("receive_#{queue}", msg)
        end
      end
    end
  end
end

if __FILE__ == $0

  class Foo < RedActor::Actor
    
    mailbox :foo
    mailbox :bar
    
    def receive_foo(msg)
      p [:receive_foo, msg]
      send_msg 'bar', msg + ' world'
    end
    
    def receive_bar(msg)
      p [:receive_bar, msg]
    end
    
  end
  
  
  RedActor.run
end
