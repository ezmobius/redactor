require 'rubygems'
require 'redis'
require 'json'
require 'redactor/actor'

module RedActor
  class << self
    attr_accessor :redis_options, :threads
    
    def run(opts={})
      opts[:timeout] ||= 15
      RedActor.redis_options = opts
      RedActor.threads.each {|t| t.join }
    end
  end
end

