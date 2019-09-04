require "./context"

class HTTP::Proxy::Handler
  include HTTP::Handler

  property next : Handler | Proc | Nil

  alias Proc = HTTP::Proxy::Server::Context ->

  def call(context)
    request = context.request
    response = context.response
    context = HTTP::Proxy::Server::Context.new(request, response)
    call_next(context)
    context.perform
  end
end
