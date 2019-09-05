require "./context"

class HTTP::Proxy::Handler
  include HTTP::Handler

  property next : Handler | Proc | Nil

  alias Proc = HTTP::Proxy::Server::Context ->

  def initialize(@proxy_addresses : Proxylist::Getter)
  end

  def call(context)
    request = context.request
    response = context.response
    context = HTTP::Proxy::Server::Context.new(request, response, @proxy_addresses)
    call_next(context)
    context.perform
  end
end
