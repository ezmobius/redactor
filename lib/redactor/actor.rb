module RedActor
  
  class Actor
    class << self
      def mailbox(queue)
        RedActor.queues ||= {}
        RedActor.queues[queue.to_s] = self
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