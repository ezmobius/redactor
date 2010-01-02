module RedActor
  
  class Actor
    class << self
      def mailbox(queue)
        thread = Thread.new do
          sleep 0.1 until RedActor.redis_options
          redis = Redis.new(RedActor.redis_options)
          loop do
            msg = redis.blpop(queue, 10)
            if msg
              self.new(redis).__send__("receive_#{queue}", msg)
            end
          end
        end
        RedActor.threads ||= []
        RedActor.threads << thread
      end
    end
    
    def initialize(redis)
      @redis = redis
    end
    
    
    def send_msg(mailbox, msg)
      @redis.rpush(mailbox, msg)
    end
  end
end