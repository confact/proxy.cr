require "./context"

class Proxy::Rotator::Handler
  include HTTP::Handler

  property next : Handler | Proc | Nil

  alias Proc = Proxy::Rotator::Server::Context ->

  def initialize(@proxy_addresses : Proxy::Rotator::Getter)
  end

  def call(context)
    request = context.request
    response = context.response
    context = Proxy::Rotator::Server::Context.new(request, response, @proxy_addresses)
    call_next(context)
    context.perform
  end
end
