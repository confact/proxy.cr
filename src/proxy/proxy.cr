require "http/client"
require "http/server"
require "./rotator/handler"
require "./rotator/response"
require "./rotator/basic_auth"
require "./rotator/getter"

class Proxy::Rotator::Server < HTTP::Server

  def self.new(port)
    new("127.0.0.1", port)
  end

  def self.new(port, &handler : Proxy::Rotator::Handler::Proc)
    new("127.0.0.1", port, &handler)
  end

  def self.new(port, handlers : Array(HTTP::Handler), &handler : HTTP::Proxy::Handler::Proc)
    new("127.0.0.1", port, handlers, &handler)
  end

  def self.new(port, handlers : Array(HTTP::Handler))
    new("127.0.0.1", port, handlers)
  end

  def self.new(port, handler)
    new("127.0.0.1", port, handler)
  end

  def initialize(@host : String, @port : Int32)
    handler = Proxy::Rotator::Server.build_middleware
    @processor = RequestProcessor.new handler
  end

  def initialize(@host : String, @port : Int32, &handler : Proxy::Rotator::Handler::Proc)
    handler = Proxy::Rotator::Server.build_middleware handler
    @processor = RequestProcessor.new handler
  end

  def initialize(@host : String, @port : Int32, handlers : Array(HTTP::Handler), &handler : Proxy::Rotator::Handler::Proc)
    handler = HTTP::Proxy::Server.build_middleware handlers, handler
    @processor = RequestProcessor.new handler
  end

  def initialize(@host : String, @port : Int32, handlers : Array(HTTP::Handler))
    handler = Proxy::Rotator::Server.build_middleware handlers
    @processor = RequestProcessor.new handler
  end

  def initialize(@host : String, @port : Int32, handler : HTTP::Handler | Proxy::Rotator::Handler::Proc)
    handler = Proxy::Rotator::Server.build_middleware handler
    @processor = RequestProcessor.new handler
  end

  def self.build_middleware(handler : Proxy::Rotator::Handler::Proc? = nil)
    proxy_addresses = Proxy::Rotator::Getter.new
    proxy_handler = Proxy::Rotator::Handler.new(proxy_addresses)
    proxy_handler.next = handler if handler
    proxy_handler
  rescue Proxy::Rotator::Getter::Exception
    puts "Couldn't find proxylist file - exiting"
    exit(0)
  end

  def self.build_middleware(handlers, last_handler : Proxy::Rotator::Handler::Proc? = nil)
    proxy_handler = build_middleware last_handler
    return proxy_handler if handlers.empty?

    handlers.each_cons(2) do |group|
      group[0].next = group[1]
    end
    handlers.last.next = proxy_handler if proxy_handler

    handlers.first
  end
end
